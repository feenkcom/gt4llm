Class {
	#name : #GtLlmToolForRemoteExampleMethodsRunExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : #'Gt4Llm-Examples'
}

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
	errorDictionary := result at: 'error'.
	message := errorDictionary at: 'message'.
	self assert: message equals: 'Check names not provided'.
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
	errorDictionary := result at: 'error'.
	message := errorDictionary at: 'message'.
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
	errorDictionary := result at: 'error'.
	message := errorDictionary at: 'message'.
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
    results := result at: 'results'.
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
	results := result at: 'results'.
	self assert: results size equals: 3.
	self assert: (results collect: [ :resultDictionary |
		resultDictionary at: 'result' ] as: Set) equals:
		#('pass' 'failure' 'error') asSet.
	^ tool
]

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> exampleRunSuccessEmptyChanges [
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
			'changes' -> '[]'.
		} asDictionary
	} asDictionary.
	resultString := tool performToolCall: call.
	result := STONJSON fromString: resultString.
	self assert: call tool == tool.
	self assert: result class name equals: #Dictionary.
	self assert: result size equals: 1.
	results := result at: 'results'.
	self assert: results size equals: 1.
	self assert: (results first at: 'result') equals: 'pass'.
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
	results := result at: 'results'.
	self assert: results size equals: 1.
	self assert: (results first at: 'result') equals: 'pass'.
	^ tool
]

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> exampleRunWithHashSelectors [
    "Ensure #example selectors are normalized"
    <gtExample>
    | tool call result |
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
    self
        assert: ((result at: 'results') first at: 'result')
        equals: 'pass'.
]

{ #category : #examples }
GtLlmToolForRemoteExampleMethodsRunExamples >> exampleSuccess [
	"Simple example that succeeds"
	<gtExample>

	self assert: true.
]
