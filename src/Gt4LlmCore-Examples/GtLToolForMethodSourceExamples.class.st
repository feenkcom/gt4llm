Class {
	#name : #GtLToolForMethodSourceExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForMethodSourceExamples >> methodSourceForExistingClassSideMethod [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> #Collection.
			'methodName' -> #withAll:.
			'classSide' -> 'true'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result sourceCode equals: (Collection class>>#withAll:) sourceCode.
	^ call
]

{ #category : #'llm-generated' }
GtLToolForMethodSourceExamples >> methodSourceForExistingInstanceSideMethod [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> GtLToolForMethodImplementors name.
							'methodName' -> #privatePerformToolCall:.
							'classSide' -> 'false'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self
		assert: result sourceCode
		equals: (GtLToolForMethodImplementors>>#privatePerformToolCall:) sourceCode.
	^ call
]

{ #category : #'llm-generated' }
GtLToolForMethodSourceExamples >> methodSourceForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> #ClassThatDoesNotExist.
			'methodName' -> 'unknownSelector42'.
			'classSide' -> 'class'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result objectName equals: 'ClassThatDoesNotExist'.
	^ call
]

{ #category : #'llm-generated' }
GtLToolForMethodSourceExamples >> methodSourceForUnknownClassSideMethod [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> GtLToolForMethodImplementors name.
			'methodName' -> 'unknownSelector42'.
			'classSide' -> 'class'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result objectName equals: GtLToolForMethodImplementors name, '>>#unknownSelector42'.
	^ call
]

{ #category : #'llm-generated' }
GtLToolForMethodSourceExamples >> methodSourceForUnknownInstanceSideMethod [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> GtLToolForMethodImplementors name.
			'methodName' -> 'unknownSelector42'.
			'classSide' -> 'false'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result objectName equals: GtLToolForMethodImplementors name, '>>#unknownSelector42'.
	^ call
]
