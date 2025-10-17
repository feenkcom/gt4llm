Class {
	#name : #GtLlmToolForRemoteExampleMethodsRunExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : #'Gt4Llm-Examples'
}

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> exampleRunSuccess [
	"Confirm that the GtLlmToolForRemoteExampleMethodsRun tool behaves as expected in the case where a collection of changes that don't exist in the main image is provided and a collection of examples that depends on the changes is run."
	<gtExample>
	<noTest>
	| tool call resultString result results exampleNamePrefix |

	tool := GtLlmToolForRemoteExampleMethodsRun new.
	call := GtLlmFunctionToolCall new.
	exampleNamePrefix := self class name asString, '>>'.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'checkNames' -> {
				exampleNamePrefix, 'exampleSuccess'.
				exampleNamePrefix, 'exampleFailure'.
				exampleNamePrefix, 'exampleError'.
				}.
			'changes' -> {
				{
					'type' -> 'method'.
					'class' -> self class name asString.
					'code' ->
'exampleSuccess
	<gtExample>

	^ self assert: true.'.
				} asDictionary.
				{
					'type' -> 'method'.
					'class' -> self class name asString.
					'code' ->
'exampleFailure
	<gtExample>

	^ self assert: false.'.
				} asDictionary.
				{
					'type' -> 'method'.
					'class' -> self class name asString.
					'code' ->
'exampleError
	<gtExample>

	^ self error: ''an error''.'.
				} asDictionary. }.
		} asDictionary
	} asDictionary.
	resultString := tool performToolCall: call.
	result := STONJSON fromString: resultString.
	self assert: call tool == tool.
	self assert: result class name equals: #Dictionary.
	self assert: result size equals: 1.
	results := result at: 'results'.
	self assert: results size equals: 3.
	self assert: (results collect: [ :resultDictionary |
		resultDictionary at: 'result' ] as: Set) equals:
		#('pass' 'failure' 'error') asSet.
	^ tool
]
