Class {
	#name : #GtLToolForMethodCompilationExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
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
	(metaClass includesSelector: selector)
		ifTrue: [ metaClass removeSelector: selector ].
	[ call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> #GtLToolForMethodCompilationExamples.
							'sourceCode' -> source.
							'protocol' -> 'examples'.
							'classSide' -> 'true'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: (metaClass includesSelector: selector).
	self
		assert: result method
		equals: metaClass >> #gtCompiledExampleClassSideMethod.
	self assert: result oldSourceCode isNil.
	self assert: result newSourceCode equals: source ]
		ensure: [ (metaClass includesSelector: selector)
				ifTrue: [ metaClass removeSelector: selector ] ].
	^ call
]

{ #category : #examples }
GtLToolForMethodCompilationExamples >> compileInstanceSideMethod [
	<gtExample>
	| tool call result selector targetClass source |
	selector := #gtCompiledExampleInstanceMethod.
	targetClass := GtLToolForMethodCompilationExamples.
	source := 'gtCompiledExampleInstanceMethod ^ 42'.
	tool := GtLToolForMethodCompilation new.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	[ call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> #GtLToolForMethodCompilationExamples.
							'sourceCode' -> source.
							'protocol' -> 'examples'.
							'classSide' -> 'false'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: (targetClass includesSelector: selector).
	self assert: result method equals: targetClass >> selector.
	self assert: result oldSourceCode isNil.
	self assert: result newSourceCode equals: source ]
		ensure: [ (targetClass includesSelector: selector)
				ifTrue: [ targetClass removeSelector: selector ] ].
	^ call
]

{ #category : #examples }
GtLToolForMethodCompilationExamples >> compileInstanceSideMethodWithEmptyProtocol [
	<gtExample>
	| tool call result selector targetClass source |
	selector := #gtCompiledExampleEmptyProtocol.
	targetClass := GtLToolForMethodCompilationExamples.
	source := 'gtCompiledExampleEmptyProtocol ^ 10'.
	tool := GtLToolForMethodCompilation new.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	[ call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> #GtLToolForMethodCompilationExamples.
							'sourceCode' -> source.
							'protocol' -> ''.
							'classSide' -> 'false'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: (targetClass includesSelector: selector).
	self
		assert: (targetClass organization protocolNameOfSelector: selector)
		equals: 'as yet unclassified'.
	self assert: result newSourceCode equals: source ]
		ensure: [ (targetClass includesSelector: selector)
				ifTrue: [ targetClass removeSelector: selector ] ].
	^ call
]

{ #category : #examples }
GtLToolForMethodCompilationExamples >> compileInstanceSideMethodWithExistingSource [
	<gtExample>
	| tool call result selector targetClass sourceBefore sourceAfter |
	selector := #gtCompiledExampleInstanceExisting.
	targetClass := GtLToolForMethodCompilationExamples.
	sourceBefore := 'gtCompiledExampleInstanceExisting ^ 1'.
	sourceAfter := 'gtCompiledExampleInstanceExisting ^ 2'.
	targetClass compile: sourceBefore classified: 'examples'.
	tool := GtLToolForMethodCompilation new.
	[ call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> #GtLToolForMethodCompilationExamples.
							'sourceCode' -> sourceAfter.
							'protocol' -> 'examples'.
							'classSide' -> 'false'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result method equals: targetClass >> selector.
	self assert: result oldSourceCode equals: sourceBefore.
	self assert: result newSourceCode equals: sourceAfter ]
		ensure: [ (targetClass includesSelector: selector)
				ifTrue: [ targetClass removeSelector: selector ] ].
	^ call
]

{ #category : #examples }
GtLToolForMethodCompilationExamples >> compileInstanceSideMethodWithMissingProtocol [
	<gtExample>
	| tool call result selector targetClass source |
	selector := #gtCompiledExampleMissingProtocol.
	targetClass := GtLToolForMethodCompilationExamples.
	source := 'gtCompiledExampleMissingProtocol ^ 9'.
	tool := GtLToolForMethodCompilation new.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	[ call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> #GtLToolForMethodCompilationExamples.
							'sourceCode' -> source.
							'classSide' -> 'false'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: (targetClass includesSelector: selector).
	self
		assert: (targetClass organization protocolNameOfSelector: selector)
		equals: 'as yet unclassified'.
	self assert: result newSourceCode equals: source ]
		ensure: [ (targetClass includesSelector: selector)
				ifTrue: [ targetClass removeSelector: selector ] ].
	^ call
]

{ #category : #examples }
GtLToolForMethodCompilationExamples >> compileMethodForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodCompilation new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> #ClassThatDoesNotExist.
							'sourceCode' -> 'someMethod ^ 1'.
							'protocol' -> 'examples'.
							'classSide' -> 'false'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result objectName equals: 'ClassThatDoesNotExist'.
	^ call
]

{ #category : #examples }
GtLToolForMethodCompilationExamples >> compileMethodWithMissingClassName [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodCompilation new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'sourceCode' -> 'gtCompiledExampleMissingClassName ^ 1'.
							'protocol' -> 'examples'.
							'classSide' -> 'false'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result missingArgument equals: 'className'.
	^ call
]

{ #category : #examples }
GtLToolForMethodCompilationExamples >> compileMethodWithMissingSourceCode [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodCompilation new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> #GtLToolForMethodCompilationExamples.
							'protocol' -> 'examples'.
							'classSide' -> 'false'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result missingArgument equals: 'sourceCode'.
	^ call
]

{ #category : #examples }
GtLToolForMethodCompilationExamples >> compileMethodWithSyntaxError [
	<gtExample>
	| tool call result selector targetClass |
	targetClass := GtLToolForMethodCompilationExamples.
	selector := #gtCompiledExampleWithSyntaxError.
	tool := GtLToolForMethodCompilation new.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	[ call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> #GtLToolForMethodCompilationExamples.
							'sourceCode' -> 'gtCompiledExampleWithSyntaxError ^'.
							'protocol' -> 'examples'.
							'classSide' -> 'false'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: (result description beginsWith: 'Syntax error').
	self assert: (targetClass includesSelector: selector) not ]
		ensure: [ (targetClass includesSelector: selector)
				ifTrue: [ targetClass removeSelector: selector ] ].
	^ call
]
