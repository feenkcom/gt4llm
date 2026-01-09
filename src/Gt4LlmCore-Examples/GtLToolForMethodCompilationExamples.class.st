Class {
	#name : #GtLToolForMethodCompilationExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLToolForMethodCompilationExamples >> compileClassSideMethod [
	<gtExample>
	| tool call result selector targetClass metaClass source |
	selector := #gtCompiledExampleClassSideMethod.
	targetClass := GtLToolForMethodCompilationExamples.
	metaClass := targetClass class.
	source := 'gtCompiledExampleClassSideMethod ^ ''class'''.
	tool := GtLToolForMethodCompilation new.
	(metaClass includesSelector: selector) ifTrue: [ metaClass removeSelector: selector ].
	[
		call := GtLFunctionToolCall new.
		call function: {
			'name' -> tool name.
			'arguments' -> {
				'className' -> #GtLToolForMethodCompilationExamples.
				'sourceCode' -> source.
				'protocol' -> 'examples'.
				'classSide' -> 'true'
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: result equals: 'Method compiled: GtLToolForMethodCompilationExamples class>>#gtCompiledExampleClassSideMethod'.
		self assert: (metaClass includesSelector: selector)
	] ensure: [
		(metaClass includesSelector: selector) ifTrue: [ metaClass removeSelector: selector ]
	].
	^ tool
]

{ #category : #examples }
GtLToolForMethodCompilationExamples >> compileInstanceSideMethod [
	<gtExample>
	| tool call result selector targetClass source |
	selector := #gtCompiledExampleInstanceMethod.
	targetClass := GtLToolForMethodCompilationExamples.
	source := 'gtCompiledExampleInstanceMethod ^ 42'.
	tool := GtLToolForMethodCompilation new.
	(targetClass includesSelector: selector) ifTrue: [ targetClass removeSelector: selector ].
	[
		call := GtLFunctionToolCall new.
		call function: {
			'name' -> tool name.
			'arguments' -> {
				'className' -> #GtLToolForMethodCompilationExamples.
				'sourceCode' -> source.
				'protocol' -> 'examples'.
				'classSide' -> 'false'
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: result equals: 'Method compiled: GtLToolForMethodCompilationExamples>>#gtCompiledExampleInstanceMethod'.
		self assert: (targetClass includesSelector: selector)
	] ensure: [
		(targetClass includesSelector: selector) ifTrue: [ targetClass removeSelector: selector ]
	].
	^ tool
]

{ #category : #examples }
GtLToolForMethodCompilationExamples >> compileMethodForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodCompilation new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> #ClassThatDoesNotExist.
			'sourceCode' -> 'someMethod ^ 1'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Class not found'.
	^ tool
]

{ #category : #examples }
GtLToolForMethodCompilationExamples >> compileMethodWithSyntaxError [
	<gtExample>
	| tool call result selector targetClass |
	targetClass := GtLToolForMethodCompilationExamples.
	selector := #gtCompiledExampleWithSyntaxError.
	tool := GtLToolForMethodCompilation new.
	(targetClass includesSelector: selector) ifTrue: [ targetClass removeSelector: selector ].
	[
		call := GtLFunctionToolCall new.
		call function: {
			'name' -> tool name.
			'arguments' -> {
				'className' -> #GtLToolForMethodCompilationExamples.
				'sourceCode' -> 'gtCompiledExampleWithSyntaxError ^'.
				'protocol' -> 'examples'.
				'classSide' -> 'false'
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result beginsWith: 'Syntax error').
		self assert: (targetClass includesSelector: selector) not
	] ensure: [
		(targetClass includesSelector: selector) ifTrue: [ targetClass removeSelector: selector ]
	].
	^ tool
]
