Class {
	#name : #GtLToolForMethodsSourceExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLToolForMethodsSourceExamples >> methodSourcesForExistingMethods [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'methods' -> {
				{'className' -> #Collection.
					'methodName' -> #withAll:.
					'classSide' -> 'true'} asDictionary.
				{'className' -> GtLToolForMethodImplementors name.
					'methodName' -> #privatePerformToolCall:.
					'classSide' -> 'false'} asDictionary
			}
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 2.
	self
		assert: (result methods first sourceCode)
		equals: (Collection class>>#withAll:) sourceCode.
	self
		assert: (result methods second sourceCode)
		equals: (GtLToolForMethodImplementors>>#privatePerformToolCall:) sourceCode.
	^ call
]

{ #category : #examples }
GtLToolForMethodsSourceExamples >> methodSourcesForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'methods' -> {
				{'className' -> #ClassThatDoesNotExist.
					'methodName' -> 'unknownSelector42'.
					'classSide' -> 'class'} asDictionary.
				{'className' -> #Collection.
					'methodName' -> #withAll:.
					'classSide' -> 'true'} asDictionary
			} asArray
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 2.
	self assert: result methods first isErrorDomainObject.
	self assert: result methods first objectName equals: 'ClassThatDoesNotExist'.
	self assert: result methods second isErrorDomainObject not.
	^ call
]

{ #category : #examples }
GtLToolForMethodsSourceExamples >> methodSourcesForUnknownMethod [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodsSource new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'methods' -> {
				{'className' -> GtLToolForMethodImplementors name.
					'methodName' -> 'unknownSelector42'.
					'classSide' -> 'false'} asDictionary.
				{'className' -> #Collection.
					'methodName' -> #withAll:.
					'classSide' -> 'true'} asDictionary
			} asArray
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods size equals: 2.
	self assert: result methods first isErrorDomainObject.
	self assert: result methods second isErrorDomainObject not.
	self
		assert: result methods first objectName
		equals: GtLToolForMethodImplementors name, '>>#unknownSelector42'.
	^ call
]
