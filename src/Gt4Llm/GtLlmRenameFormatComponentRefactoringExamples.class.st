Class {
	#name : #GtLlmRenameFormatComponentRefactoringExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Refactorings - Examples'
}

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoringExamples >> actionSource [
	^ 'gtExampleAction
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
	    name: ''Example Action'';
	    priority: 10;
		description: ''Example Action'';
		examples: {GtLlmTutorActionExample new
	input: {''Action'' -> ''Example Action''. ''Text'' -> nil. ''Example'' -> ''Input''} asDictionary; output:{''Action'' -> ''Example Action''. ''Text'' -> nil. ''Example'' -> ''Output''} asDictionary}'
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoringExamples >> coderOnExampleClass [
	<after: #destroyClass>
	<gtExample>
	| change class |
	class := self exampleClass.
	change := class model changes.
	change execute.

	^ GtCoder forClass: class name asClass
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoringExamples >> destroyClass [
	| class |
	class := self exampleClass.
	Smalltalk removeClassNamed: class name
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoringExamples >> exampleClass [
	<gtExample>
	| model class |
	model := GtRBNamespace new.

	model
		defineClass: 'GtOpenAIAnnotatedActionTutor subclass: #ExampleTutor instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' category: ''Demo'''.
	class := model classNamed: #ExampleTutor.

	class compile: self actionSource classified: #('format-components').
	class compile: self formatSource classified: #('actions').
	^ class
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoringExamples >> exampleClassCoderActionExpanded [
	<gtExample>
	| scripter |
	scripter := self scripterOnExampleClassCoder.

	scripter
		clickStep: [ :s | 
			s
				label: 'Expand method in coder';
				id: (GtSourceCoderId indexed: 1) ].

	^ scripter
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoringExamples >> exampleClassCoderActionExpandedWithRenameDone [
	<gtExample>
	| scripter |
	scripter := self exampleClassCoderActionExpandedWithRenameOpen.

	scripter
		typeStep: [ :s | 
			s
				label: 'Type a new format componant name';
				text: 'Renamed' ].

	scripter
		clickStep: [ :s | 
			s
				label: 'Open refactoring dialog';
				// (GtSourceCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// #previewCheckButton ].

	scripter
		clickStep: [ :s | 
			s
				label: 'Expand the refactoring preview dropdown';
				onSpaceRoot;
				onDropdown: true;
				// GtChangesElement;
				// BrTriangle ].

	scripter
		doStep: [ :s | 
			s
				label: 'Setup dropdown overview';
				block: [ :aButton :aUserData | 
					aUserData
						at: BrAnchoredVisualAnalysis
						put: (BrAnchoredVisualAnalysis new elementWithDropdown: aButton) ];
				// (GtSourceCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// #previewCheckButton ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Assert dropdown bounds';
				satisfies: [ :anAsyncWidget | anAsyncWidget space root boundsInSpace containsRect: anAsyncWidget boundsInSpace ]
					description: [ 'Refactoring preview bounds is out of space' ];
				onSpaceRoot;
				onDropdown: true;
				/ BrAsyncWidget ].
	^ scripter
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoringExamples >> exampleClassCoderActionExpandedWithRenameOpen [
	<gtExample>
	| scripter |
	scripter := self exampleClassCoderActionExpanded.

	scripter
		doStep: [ :s | 
			s
				label: 'Move cursor to example';
				block: [ :anEditorElement | 
					| aMethod aPosition |
					aMethod := anEditorElement textualCoderViewModel compiledMethod.

					aPosition := aMethod sourceCode
							findString: '''Example'''
							startingAt: 1
							caseSensitive: true.

					anEditorElement editor deselecter
						all;
						deselect.
					anEditorElement editor moveCursorTo: aPosition + 1 ];
				// (GtSourceCoderId indexed: 1);
				// GtSourceCoderEditorId ].

	scripter shortcut
		label: 'Switch to tutor format refactoring mode';
		combination: BlKeyCombination primaryR;
		// (GtSourceCoderId indexed: 1);
		// GtSourceCoderEditorId;
		play.

	^ scripter
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoringExamples >> exampleClassRefactored [
	<gtExample>
	| class refactoring exampleAction exampleFormat |
	class := self exampleClass.

	refactoring := GtLlmRenameFormatComponentRefactoring
			model: class model
			rename: 'Example'
			to: 'Renamed'
			in: class.
	refactoring primitiveExecute.

	exampleAction := class methodFor: #gtExampleAction.

	self assert: exampleAction source equals: self renamedActionSource.
	
	exampleFormat := class methodFor: #gtExampleFormatComponent.

	self assert:  exampleFormat source equals: self renamedFormatSource.

	^ class
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoringExamples >> formatSource [
	^ 'gtExampleFormatComponent
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
	format: ''Text'';
	name: ''Example'';
	priority: 10;
	example: '''''
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoringExamples >> renamedActionSource [
	^ 'gtExampleAction
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
	    name: ''Example Action'';
	    priority: 10;
		description: ''Example Action'';
		examples: {GtLlmTutorActionExample new
	input: {''Action'' -> ''Example Action''. ''Text'' -> nil. ''Renamed'' -> ''Input''} asDictionary; output:{''Action'' -> ''Example Action''. ''Text'' -> nil. ''Renamed'' -> ''Output''} asDictionary}'
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoringExamples >> renamedFormatSource [
	^ 'gtExampleFormatComponent
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
	format: ''Text'';
	name: ''Renamed'';
	priority: 10;
	example: '''''
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoringExamples >> scripterOnExampleClassCoder [
	<gtExample>
	| scripter |
	scripter := BlScripter new element: self coderOnExampleClass asElement.
	^ scripter
]
