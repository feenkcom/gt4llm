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
		description: ''Example'';
		examples: {GtLlmTutorActionExample new
	input: {''Action'' -> ''Example Action''. ''Text'' -> nil. ''Example'' -> ''Input''}; output:{''Action'' -> ''Example Action''. ''Text'' -> nil. ''Example'' -> ''Output''}}'
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
		description: ''Renamed'';
		examples: {GtLlmTutorActionExample new
	input: {''Action'' -> ''Example Action''. ''Text'' -> nil. ''Renamed'' -> ''Input''}; output:{''Action'' -> ''Example Action''. ''Text'' -> nil. ''Renamed'' -> ''Output''}}'
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
