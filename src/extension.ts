// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import { outputFileSync } from 'fs-extra';
import { snakeCase } from 'lodash';
import { join } from 'path';
import * as vscode from 'vscode';
import { parse } from 'yaml';
import JsonToDart from './converter';


// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext)
{

	context.subscriptions.push(
		vscode.commands.registerCommand('json2dart.convertFromClipboard', async () =>
		{
			convertToDart();
		}));
	context.subscriptions.push(
		vscode.commands.registerCommand('json2dart.convertFromClipboardToFolder', async (e) =>
		{
			convertToDart(e.path);
		}));
	context.subscriptions.push
		(vscode.commands.registerCommand('json2dart.convertFromClipboardToFile', async (e) =>
		{
			const path = e.path.toString() as string;
			const i = Math.max(path.lastIndexOf("/"), path.lastIndexOf("\\")) + 1;
			convertToDart(e.path.substring(0, i), e.path.substring(i));
		}));
}

// this method is called when your extension is deactivated
export function deactivate() {}


async function convertToDart(folder?: string, file?: string)
{
	// The code you place here will be executed every time your command is executed
	const workspacePath = vscode.workspace.workspaceFolders?.map(e => e.uri.path) ?? [];

	// Try to find and parse pubspec.yaml, but don't fail if it doesn't exist
	let jsonToDartConfig = {
		outputFolder: "lib",
		nullSafety: true,
		mergeArrayApproach: true,
		copyWithMethod: false,
		nullValueDataType: "dynamic"
	};

	try
	{
		if(workspacePath.length > 0)
		{
			const pubspecPath = join(...workspacePath, "pubspec.yaml");
			const pubspec = await vscode.workspace.openTextDocument(pubspecPath);
			const pubspecTree = parse(pubspec.getText());

			// Merge with existing config if jsonToDart section exists
			if(pubspecTree?.jsonToDart)
			{
				jsonToDartConfig = {
					...jsonToDartConfig,
					...pubspecTree.jsonToDart
				};
			}
		}
	} catch(error)
	{
		// If pubspec.yaml doesn't exist or can't be read, use default config
		console.log("pubspec.yaml not found or couldn't be read, using default configuration");
		// Silently use default configuration - no need to show message to user
	}
	// Display a message box to the user
	const value = await vscode.window.showInputBox({
		placeHolder: file || folder ? "Class Name" : "package.Class Name\n",
	});

	if(!value || value === "")
	{
		return;
	}

	const packageAndClass = value?.toString() ?? "";

	const paths = packageAndClass.split(".");
	const className = paths.pop() ?? "";
	let fileName: string;
	if(file)
	{
		fileName = file;
	} else
	{
		fileName = await filenameHandler(`${ snakeCase(className) }.dart`);
	}

	try
	{
		// Validate workspace and path construction
		if(workspacePath.length === 0 && !folder)
		{
			throw new Error("No workspace folder found and no target folder specified. Please open a workspace or specify a target folder.");
		}

		let filePath: string;
		if(folder)
		{
			// When a specific folder is provided - use absolute path as-is
			filePath = join(folder, fileName);
		} else
		{
			// Default to workspace with lib folder
			if(workspacePath.length === 0)
			{
				throw new Error("No workspace folder is open. Please open a Flutter project or specify a target folder.");
			}
			filePath = join(workspacePath[0], jsonToDartConfig.outputFolder, ...paths, fileName);
		}

		// File will be created at: ${filePath} (no need to show this to user)

		// Validate clipboard data
		const data = await vscode.env.clipboard.readText();
		if(!data || data.trim() === "")
		{
			throw new Error("Clipboard is empty. Please copy valid JSON data to clipboard.");
		}

		let obj;
		try
		{
			obj = JSON.parse(data);
		} catch(parseError)
		{
			throw new Error(`Invalid JSON in clipboard: ${ (parseError as Error).message }`);
		}

		// Get configuration values with proper defaults
		const nullSafety = jsonToDartConfig.nullSafety ?? true;
		const mergeArrayApproach = jsonToDartConfig.mergeArrayApproach ?? true;
		const copyWithMethod = jsonToDartConfig.copyWithMethod ?? false;
		const nullValueDataType = jsonToDartConfig.nullValueDataType ?? "dynamic";

		// Get tab size with fallback
		const editorConfig = vscode.workspace.getConfiguration("editor", { languageId: "dart" });
		const tabSize = editorConfig.get("tabSize") ?? 2;

		const converter = new JsonToDart(tabSize as number, undefined, nullValueDataType, nullSafety);
		converter.setIncludeCopyWitMethod(copyWithMethod);
		converter.setMergeArrayApproach(mergeArrayApproach);

		const code = converter.parse(className, obj).map(r => r.code).join("\n");
		outputFileSync(filePath, code);

		vscode.window.showInformationMessage(`✅ Dart class generated successfully: ${ fileName }`);

		// Open the generated file
		const document = await vscode.workspace.openTextDocument(filePath);
		await vscode.window.showTextDocument(document);

	} catch(e)
	{
		const errorMessage = (e as Error).message;
		console.error("json2dart conversion error:", errorMessage);
		vscode.window.showErrorMessage(`❌ Conversion failed: ${ errorMessage }`);
	}
}

const filenameHandler = async (fileName: string): Promise<string> =>
{
	const confirmFilename =
		await vscode.window.showQuickPick(["Yes", "No"], {
			placeHolder: `Use ${ fileName } as file name?`
		});

	if(confirmFilename !== "Yes")
	{
		const value = await vscode.window.showInputBox({
			placeHolder: "Please input file Name\n"
		});

		if(!value || value.trim() === "")
		{
			return await filenameHandler(fileName);
		} else
		{
			return value.endsWith(".dart") ? value : value + ".dart";
		}
	}
	return fileName;
};