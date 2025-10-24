Class {
	#name : #GtLlmToolForRemoteExampleMethodsRunExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : #'Gt4Llm-Examples'
}

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> addClassToEventFactory [
	"Confirm that class definitions are added as expected to the event factory"
	<gtExample>
	| tool eventFactory classDefinition omEntry epClassAddition rgClassAddition |

	tool := GtLlmToolForRemoteExampleMethodsRun new.
	eventFactory := GtEpiceaEventFactory new.
	classDefinition := {
		'type' -> 'class'.
		'code' ->
'Object << #SomeClass
	slots: #(someSlotA someSlotB);
	sharedVariables: #(ClassVar1 ClassVar2);
	package: ''SomePackage'''.
		} asDictionary.
	tool addClass: classDefinition to: eventFactory.

	self assert: eventFactory entries size equals: 1.
	omEntry := eventFactory entries first.
	epClassAddition := omEntry content.
	self assert: epClassAddition class equals: EpClassAddition.
	self assert: epClassAddition behaviorAffectedName equals: #SomeClass.
	rgClassAddition := epClassAddition behaviorAffected.
	self assert: (rgClassAddition instanceVariables collect: #name as: Array)
		equals: #(someSlotA someSlotB).
	self assert: (rgClassAddition classVariables collect: #name as: Array)
		equals: #(ClassVar1 ClassVar2).
]

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> exampleRunFailsWithoutCheckNames [
    "Expect the tool to signal the missing checkNames error"
    <gtExample>
    | tool call resultString result errorDictionary message |
    tool := GtLlmToolForRemoteExampleMethodsRun new.
    call := GtLlmFunctionToolCall new.
    call function: {
        'name' -> tool name.
        'arguments' -> { 'changes' -> '[]' } asDictionary
    } asDictionary.
    resultString := tool performToolCall: call.
	result := STONJSON fromString: resultString.
	errorDictionary := result at: 'error' ifAbsent:
		[ self error: '''error'' not found in: ', (STONJSON toStringPretty: result) ].
	message := errorDictionary at: 'message' ifAbsent:
		[ self error: '''message'' not found in: ', (STONJSON toStringPretty: errorDictionary) ].
	self assert: message equals: 'Check names not provided'.
]

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> exampleRunNewClassDefinition [
	"Confirm that the GtLlmToolForRemoteExampleMethodsRun tool behaves as expected in the case where
	- the changes define a new class
	- an example that checks for the existence of the class passes
	- neither the class or example exist in the main image"
	<gtExample>
	| tool call resultString result results exampleNamePrefix exampleClassDefinition exampleSource exampleClassName exampleSelector resultDictionary |

	tool := GtLlmToolForRemoteExampleMethodsRun new.
	call := GtLlmFunctionToolCall new.
	exampleClassName := #GtLlmToolForRemoteExampleMethodsRunExamplesTestClass.
	exampleSelector := #checkExampleTestClassPresence.
	self assert: (self class environment classOrTraitNamed: exampleClassName) isNil
		description: [ 'The example class ', exampleClassName asString, ' already exists' ].
	self assert: (self class lookupSelector: exampleSelector) isNil
		description: [ 'The example method ', exampleSelector asString, ' already exists' ].
	exampleNamePrefix := self class name asString, '>>'.
	exampleClassDefinition := String streamContents: [ :stream |
		stream
			<< 'Object << ';
			print: exampleClassName;
			cr; tab;
			<< 'package: ';
			print: self class package name asString ].
	exampleSource := String streamContents: [ :stream |
		stream
			<< exampleSelector;
			cr;
			cr; tab;
			<< 'self assert: (self class environment classOrTraitNamed: ';
			print: exampleClassName;
			<< ') isNotNil.' ].
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'checkNames' -> (STONJSON toString: {
				exampleNamePrefix, exampleSelector.
				}).
			'changes' -> (STONJSON toString: {
				{
					'type' -> 'method'.
					'class' -> self class name asString.
					'code' -> exampleSource.
				} asDictionary.
				{
					'type' -> 'class'.
					'code' -> exampleClassDefinition.
				} asDictionary })
		} asDictionary
	} asDictionary.
	resultString := tool performToolCall: call.
	result := STONJSON fromString: resultString.
	self assert: call tool == tool.
	self assert: result class name equals: #Dictionary.
	self assert: result size equals: 1.
	results := result at: 'results' ifAbsent:
		[ self error: '''results'' not found in: ', (STONJSON toStringPretty: result) ].
	self assert: results size equals: 1.
	resultDictionary := results first at: 'result' ifAbsent:
		[ self error: '''result'' not found in: ', (STONJSON toStringPretty: resultDictionary) ].
	self assert: resultDictionary equals: 'pass'.
	^ tool
]

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> exampleRunRejectsNonArrayCheckNames [
    "checkNames must deserialize to an Array"
    <gtExample>
    | tool call resultString result errorDictionary message |
    tool := GtLlmToolForRemoteExampleMethodsRun new.
    call := GtLlmFunctionToolCall new.
    call function: {
        'name' -> tool name.
        'arguments' -> {
            'checkNames' -> '"not-an-array"'.
        } asDictionary
    } asDictionary.
    resultString := tool performToolCall: call.
	result := STONJSON fromString: resultString.
	errorDictionary := result at: 'error' ifAbsent:
		[ self error: '''error'' not found in: ', (STONJSON toStringPretty: result) ].
	message := errorDictionary at: 'message' ifAbsent:
		[ self error: '''message'' not found in: ', (STONJSON toStringPretty: errorDictionary) ].
	self assert: message equals: 'checkNames must be an Array, not a ByteString'.
]

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> exampleRunRejectsUnknownChangeType [
    "Non-method change dictionaries should fail fast"
    <gtExample>
    | tool call resultString result errorDictionary message |
    tool := GtLlmToolForRemoteExampleMethodsRun new.
    call := GtLlmFunctionToolCall new.
    call function: {
        'name' -> tool name.
        'arguments' -> {
            'checkNames' -> (STONJSON toString: {
                self class name asString, '>>exampleSuccess'
            }).
            'changes' -> (STONJSON toString: {
                {
                    'type' -> 'junk'.
                    'junk' -> 'rubbish'.
                } asDictionary
            }).
        } asDictionary
    } asDictionary.
    resultString := tool performToolCall: call.
	result := STONJSON fromString: resultString.
	errorDictionary := result at: 'error' ifAbsent:
		[ self error: '''error'' not found in: ', (STONJSON toStringPretty: result) ].
	message := errorDictionary at: 'message' ifAbsent:
		[ self error: '''message'' not found in: ', (STONJSON toStringPretty: errorDictionary) ].
	self assert: message equals: 'Unknown type: ''junk'''.
]

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> exampleRunReportsDetailsForFailures [
    "Ensure failure entries include message and stackTrace"
    <gtExample>
    | tool call result results message |
    tool := GtLlmToolForRemoteExampleMethodsRun new.
    call := GtLlmFunctionToolCall new.
    call function: {
        'name' -> tool name.
        'arguments' -> {
            'checkNames' -> (STONJSON toString: {
                self class name asString, '>>exampleSuccess'.
                self class name asString, '>>exampleFailure'.
            }).
            'changes' -> (STONJSON toString: {
                {
                    'type' -> 'method'.
                    'class' -> self class name asString.
                    'code' -> 'exampleFailure
    <gtExample>
    ^ self assert: false'.
                } asDictionary
            }).
        } asDictionary
    } asDictionary.
    result := STONJSON fromString: (tool performToolCall: call).
    results := result at: 'results' ifAbsent:
		[ self error: '''results'' not found in: ', (STONJSON toStringPretty: result) ].
    message := (results detect: 
    	[ :each | (each at: 'method') = 'exampleFailure' ])
        	at: 'message'.
    self assert: message equals: 'Assertion failed'.
]

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> exampleRunSuccess [
	"Confirm that the GtLlmToolForRemoteExampleMethodsRun tool behaves as expected in the case where a collection of changes that don't exist in the main image is provided and a collection of examples that depends on the changes is run."
	<gtExample>
	| tool call resultString result results exampleNamePrefix |

	tool := GtLlmToolForRemoteExampleMethodsRun new.
	call := GtLlmFunctionToolCall new.
	exampleNamePrefix := self class name asString, '>>'.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'checkNames' -> (STONJSON toString: {
				exampleNamePrefix, 'exampleSuccess'.
				exampleNamePrefix, 'exampleFailure'.
				exampleNamePrefix, 'exampleError'.
				}).
			'changes' -> (STONJSON toString: {
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
				} asDictionary. }).
		} asDictionary
	} asDictionary.
	resultString := tool performToolCall: call.
	result := STONJSON fromString: resultString.
	self assert: call tool == tool.
	self assert: result class name equals: #Dictionary.
	self assert: result size equals: 1.
	results := result at: 'results' ifAbsent:
		[ self error: '''results'' not found in: ', (STONJSON toStringPretty: result) ].
	self assert: results size equals: 3.
	self assert: (results collect: [ :resultDictionary |
		resultDictionary at: 'result' ifAbsent:
			[ self error: '''result'' not found in: ', (STONJSON toStringPretty: resultDictionary) ] ] as: Set) equals:
		#('pass' 'failure' 'error') asSet.
	^ tool
]

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> exampleRunSuccessEmptyChanges [
	"Confirm that the GtLlmToolForRemoteExampleMethodsRun tool behaves as expected in the case where a collection of changes that don't exist in the main image is provided and a collection of examples that depends on the changes is run."
	<gtExample>
	| tool call resultString result results exampleNamePrefix testResult |

	tool := GtLlmToolForRemoteExampleMethodsRun new.
	call := GtLlmFunctionToolCall new.
	exampleNamePrefix := self class name asString, '>>'.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'checkNames' -> (STONJSON toString: {
				exampleNamePrefix, 'exampleSuccess'.
				}).
			'changes' -> '[]'.
		} asDictionary
	} asDictionary.
	resultString := tool performToolCall: call.
	result := STONJSON fromString: resultString.
	self assert: call tool == tool.
	self assert: result class name equals: #Dictionary.
	self assert: result size equals: 1.
	results := result at: 'results' ifAbsent:
		[ self error: '''results'' not found in: ', (STONJSON toStringPretty: result) ].
	self assert: results size equals: 1.
	testResult := results first at: 'result' ifAbsent:
		[ self error: '''result'' not found in: ', (STONJSON toStringPretty: testResult)].
	self assert: testResult equals: 'pass'.
	^ tool
]

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> exampleRunSuccessNoChanges [
	"Confirm that the GtLlmToolForRemoteExampleMethodsRun tool behaves as expected in the case where a collection of changes that don't exist in the main image is provided and a collection of examples that depends on the changes is run."
	<gtExample>
	| tool call resultString result results exampleNamePrefix |

	tool := GtLlmToolForRemoteExampleMethodsRun new.
	call := GtLlmFunctionToolCall new.
	exampleNamePrefix := self class name asString, '>>'.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'checkNames' -> (STONJSON toString: {
				exampleNamePrefix, 'exampleSuccess'.
				}).
		} asDictionary
	} asDictionary.
	resultString := tool performToolCall: call.
	result := STONJSON fromString: resultString.
	self assert: call tool == tool.
	self assert: result class name equals: #Dictionary.
	self assert: result size equals: 1.
	results := result at: 'results' ifAbsent:
		[ self error: '''results'' not found in: ', (STONJSON toStringPretty: result) ].
	self assert: results size equals: 1.
	self assert: (results first at: 'result') equals: 'pass'.
	^ tool
]

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> exampleRunWithHashSelectors [
    "Ensure #example selectors are normalized"
    <gtExample>
    | tool call result results |
    tool := GtLlmToolForRemoteExampleMethodsRun new.
    call := GtLlmFunctionToolCall new.
    call function: {
        'name' -> tool name.
        'arguments' -> {
            'checkNames' -> (STONJSON toString: {
                self class name asString, '>>#exampleSuccess'
            }).
        } asDictionary
    } asDictionary.
    result := STONJSON fromString: (tool performToolCall: call).
    results := result at: 'results' ifAbsent:
		[ self error: '''results'' not found in: ', (STONJSON toStringPretty: result) ].
    self
        assert: (results first at: 'result')
        equals: 'pass'.
]

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> exampleSuccess [
	"Simple example that succeeds"
	<gtExample>

	self assert: true.
]
