Class {
	#name : #GtLToolForMethodsCompilationExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForMethodsCompilationExamples >> compileInstanceSideMethods [
	<gtExample>
	| tool call result targetClass selectorOne selectorTwo sources |
	tool := GtLToolForMethodsCompilation new.
	targetClass := GtLToolForMethodsCompilationExamples.
	selectorOne := #gtCompiledExampleInstanceOne.
	selectorTwo := #gtCompiledExampleInstanceTwo.
	(targetClass includesSelector: selectorOne)
		ifTrue: [ targetClass removeSelector: selectorOne ].
	(targetClass includesSelector: selectorTwo)
		ifTrue: [ targetClass removeSelector: selectorTwo ].
	sources := {
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'sourceCode' -> 'gtCompiledExampleInstanceOne ^ 1'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary.
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'sourceCode' -> 'gtCompiledExampleInstanceTwo ^ 2'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary
	} asArray.
	[ call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methods' -> sources} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 2.
	self assert: (targetClass includesSelector: selectorOne).
	self assert: (targetClass includesSelector: selectorTwo).
	self assert: result methods first isErrorDomainObject not.
	self assert: result methods second isErrorDomainObject not.
	self assert: result methods first oldSourceCode isNil.
	self assert: result methods second oldSourceCode isNil.
	self assert: result methods first newSourceCode equals: 'gtCompiledExampleInstanceOne ^ 1'.
	self assert: result methods second newSourceCode equals: 'gtCompiledExampleInstanceTwo ^ 2' ]
		ensure: [
			(targetClass includesSelector: selectorOne)
				ifTrue: [ targetClass removeSelector: selectorOne ].
			(targetClass includesSelector: selectorTwo)
				ifTrue: [ targetClass removeSelector: selectorTwo ] ].
	^ call
]

{ #category : #examples }
GtLToolForMethodsCompilationExamples >> compileInstanceSideMethodsWithExistingSources [
	<gtExample>
	| tool call result targetClass selectorOne selectorTwo sources sourceBeforeOne sourceBeforeTwo |
	tool := GtLToolForMethodsCompilation new.
	targetClass := GtLToolForMethodsCompilationExamples.
	selectorOne := #gtCompiledExampleInstanceExistingOne.
	selectorTwo := #gtCompiledExampleInstanceExistingTwo.
	sourceBeforeOne := 'gtCompiledExampleInstanceExistingOne ^ 10'.
	sourceBeforeTwo := 'gtCompiledExampleInstanceExistingTwo ^ 20'.
	targetClass compile: sourceBeforeOne classified: 'examples'.
	targetClass compile: sourceBeforeTwo classified: 'examples'.
	sources := {
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'sourceCode' -> 'gtCompiledExampleInstanceExistingOne ^ 11'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary.
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'sourceCode' -> 'gtCompiledExampleInstanceExistingTwo ^ 21'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary
	} asArray.
	[ call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methods' -> sources} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 2.
	self assert: result methods first oldSourceCode equals: sourceBeforeOne.
	self assert: result methods second oldSourceCode equals: sourceBeforeTwo.
	self assert: result methods first newSourceCode equals: 'gtCompiledExampleInstanceExistingOne ^ 11'.
	self assert: result methods second newSourceCode equals: 'gtCompiledExampleInstanceExistingTwo ^ 21' ]
		ensure: [
			(targetClass includesSelector: selectorOne)
				ifTrue: [ targetClass removeSelector: selectorOne ].
			(targetClass includesSelector: selectorTwo)
				ifTrue: [ targetClass removeSelector: selectorTwo ] ].
	^ call
]

{ #category : #examples }
GtLToolForMethodsCompilationExamples >> compileMethodsForUnknownClass [
	<gtExample>
	| tool call result sources |
	tool := GtLToolForMethodsCompilation new.
	sources := {
		{'className' -> #ClassThatDoesNotExist.
			'sourceCode' -> 'gtCompiledExampleUnknown ^ 1'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary.
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'sourceCode' -> 'gtCompiledExampleKnown ^ 2'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary
	} asArray.
	[ call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methods' -> sources} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 2.
	self assert: result methods first isErrorDomainObject.
	self assert: result methods first objectName equals: 'ClassThatDoesNotExist'.
	self assert: result methods second isErrorDomainObject not.
	self assert: result methods second oldSourceCode isNil.
	self assert: result methods second newSourceCode equals: 'gtCompiledExampleKnown ^ 2' ]
		ensure: [
			(GtLToolForMethodsCompilationExamples includesSelector: #gtCompiledExampleKnown)
				ifTrue: [ GtLToolForMethodsCompilationExamples removeSelector: #gtCompiledExampleKnown ] ].
	^ call
]

{ #category : #examples }
GtLToolForMethodsCompilationExamples >> compileMethodsWithEmptyProtocol [
	<gtExample>
	| tool call result targetClass selector source methods |
	tool := GtLToolForMethodsCompilation new.
	targetClass := GtLToolForMethodsCompilationExamples.
	selector := #gtCompiledExampleEmptyProtocol.
	source := 'gtCompiledExampleEmptyProtocol ^ 6'.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	methods := {{'className' -> #GtLToolForMethodsCompilationExamples.
				'sourceCode' -> source.
				'protocol' -> ''.
				'classSide' -> 'false'} asDictionary} asArray.
	[ call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'methods' -> methods} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 1.
	self assert: (targetClass includesSelector: selector).
	self
		assert: (targetClass organization protocolNameOfSelector: selector)
		equals: 'as yet unclassified'.
	self assert: result methods first newSourceCode equals: source ]
		ensure: [ (targetClass includesSelector: selector)
				ifTrue: [ targetClass removeSelector: selector ] ].
	^ call
]

{ #category : #examples }
GtLToolForMethodsCompilationExamples >> compileMethodsWithMissingClassName [
	<gtExample>
	| tool call result targetClass selector source methods |
	tool := GtLToolForMethodsCompilation new.
	targetClass := GtLToolForMethodsCompilationExamples.
	selector := #gtCompiledExampleMissingClassOk.
	source := 'gtCompiledExampleMissingClassOk ^ 8'.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	methods := {
		{'sourceCode' -> 'gtCompiledExampleMissingClassName ^ 1'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary.
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'sourceCode' -> source.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary
	} asArray.
	[ call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methods' -> methods} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 2.
	self assert: result methods first isErrorDomainObject.
	self assert: result methods first missingArgument equals: 'className'.
	self assert: result methods second isErrorDomainObject not.
	self assert: (targetClass includesSelector: selector).
	self assert: result methods second newSourceCode equals: source ]
		ensure: [
			(targetClass includesSelector: selector)
				ifTrue: [ targetClass removeSelector: selector ] ].
	^ call
]

{ #category : #examples }
GtLToolForMethodsCompilationExamples >> compileMethodsWithMissingProtocol [
	<gtExample>
	| tool call result targetClass selector source methods |
	tool := GtLToolForMethodsCompilation new.
	targetClass := GtLToolForMethodsCompilationExamples.
	selector := #gtCompiledExampleMissingProtocol.
	source := 'gtCompiledExampleMissingProtocol ^ 5'.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	methods := {{'className' -> #GtLToolForMethodsCompilationExamples.
				'sourceCode' -> source.
				'classSide' -> 'false'} asDictionary} asArray.
	[ call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'methods' -> methods} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 1.
	self assert: (targetClass includesSelector: selector).
	self
		assert: (targetClass organization protocolNameOfSelector: selector)
		equals: 'as yet unclassified'.
	self assert: result methods first newSourceCode equals: source ]
		ensure: [ (targetClass includesSelector: selector)
				ifTrue: [ targetClass removeSelector: selector ] ].
	^ call
]

{ #category : #examples }
GtLToolForMethodsCompilationExamples >> compileMethodsWithMissingSourceCode [
	<gtExample>
	| tool call result targetClass selector source methods |
	tool := GtLToolForMethodsCompilation new.
	targetClass := GtLToolForMethodsCompilationExamples.
	selector := #gtCompiledExampleMissingSourceOk.
	source := 'gtCompiledExampleMissingSourceOk ^ 4'.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	methods := {
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary.
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'sourceCode' -> source.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary
	} asArray.
	[ call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methods' -> methods} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 2.
	self assert: result methods first isErrorDomainObject.
	self assert: result methods first missingArgument equals: 'sourceCode'.
	self assert: result methods second isErrorDomainObject not.
	self assert: (targetClass includesSelector: selector).
	self assert: result methods second newSourceCode equals: source ]
		ensure: [
			(targetClass includesSelector: selector)
				ifTrue: [ targetClass removeSelector: selector ] ].
	^ call
]

{ #category : #examples }
GtLToolForMethodsCompilationExamples >> compileMethodsWithSyntaxError [
	<gtExample>
	| tool call result sources selector targetClass |
	tool := GtLToolForMethodsCompilation new.
	selector := #gtCompiledExampleSyntaxError.
	targetClass := GtLToolForMethodsCompilationExamples.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	sources := {
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'sourceCode' -> 'gtCompiledExampleSyntaxError ^'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary.
		{'className' -> #GtLToolForMethodsCompilationExamples.
			'sourceCode' -> 'gtCompiledExampleSyntaxOkay ^ 3'.
			'protocol' -> 'examples'.
			'classSide' -> 'false'} asDictionary
	} asArray.
	[ call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methods' -> sources} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 2.
	self assert: result methods first isErrorDomainObject.
	self assert: (result methods first description beginsWith: 'Syntax error').
	self assert: result methods second isErrorDomainObject not.
	self assert: (targetClass includesSelector: #gtCompiledExampleSyntaxOkay).
	self assert: result methods second oldSourceCode isNil.
	self assert: result methods second newSourceCode equals: 'gtCompiledExampleSyntaxOkay ^ 3' ]
		ensure: [
			(targetClass includesSelector: selector)
				ifTrue: [ targetClass removeSelector: selector ].
			(targetClass includesSelector: #gtCompiledExampleSyntaxOkay)
				ifTrue: [ targetClass removeSelector: #gtCompiledExampleSyntaxOkay ] ].
	^ call
]
