Class {
	#name : #GtLMagritteToolForMethodsSourceExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForExistingMethods [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodsSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> 'Collection'.
					'methodName' -> 'withAll:'.
					'classSide' -> true} asDictionary.
				{'methodClassName' -> #GtLMagritteToolForMethodsSourceExamples.
					'methodName' -> 'methodSourcesForExistingMethods'.
					'classSide' -> false} asDictionary
			} asArray
		} asDictionary.
	self assert: (domainObject isKindOf: GtLMethodsWithSource).
	self assert: domainObject methods size equals: 2.
	self
		assert: domainObject methods first sourceCode
		equals: (Collection class>>#withAll:) sourceCode.
	self
		assert: domainObject methods second sourceCode
		equals: (GtLMagritteToolForMethodsSourceExamples>>#methodSourcesForExistingMethods) sourceCode.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForMissingArguments [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodsSource new.
	domainObject := self
		executeTool: tool
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methodDescriptors') 
		path: #(nil) 
		errorMessage: 'required properties missing [methodDescriptors]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForMissingMethodArguments [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodsSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> 'Collection'.
					'classSide' -> true} asDictionary.
				{'methodName' -> 'withAll:'.
					'classSide' -> true} asDictionary.
				{'methodClassName' -> 'Collection'.
					'methodName' -> 'withAll:'.
					'classSide' -> true} asDictionary
			} asArray
		} asDictionary.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methodName') 
		path: #('methodDescriptors' 1) 
		errorMessage: '@[methodDescriptors/1] required properties missing [methodName]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForUnknownClass [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodsSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> 'ClassThatDoesNotExist'.
					'methodName' -> 'unknownSelector42'.
					'classSide' -> true} asDictionary.
				{'methodClassName' -> 'Collection'.
					'methodName' -> 'withAll:'.
					'classSide' -> true} asDictionary
			} asArray
		} asDictionary.
	self assert: (domainObject isKindOf: GtLMethodsWithSource).
	self assert: domainObject methods size equals: 2.
	self assert: domainObject methods first isErrorDomainObject.
	self assert: (domainObject methods second isKindOf: GtLMethodWithSource).
	self assert: domainObject methods first objectName equals: 'ClassThatDoesNotExist'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForUnknownMethod [
	<gtExample>
	| tool domainObject expectedSignature |
	tool := GtLMagritteToolForMethodsSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> GtLMagritteToolForMethodImplementors name.
					'methodName' -> 'unknownSelector42'.
					'classSide' -> false} asDictionary.
				{'methodClassName' -> 'Collection'.
					'methodName' -> 'withAll:'.
					'classSide' -> true} asDictionary
			} asArray
		} asDictionary.
	self assert: (domainObject isKindOf: GtLMethodsWithSource).
	self assert: domainObject methods size equals: 2.
	self assert: domainObject methods first isErrorDomainObject.
	self assert: (domainObject methods second isKindOf: GtLMethodWithSource).
	expectedSignature := GtLMagritteToolForMethodImplementors name, '>>#unknownSelector42'.
	self assert: domainObject methods first objectName equals: expectedSignature.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithEmptyMethodClassName [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodsSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> ''.
					'methodName' -> 'withAll:'.
					'classSide' -> true} asDictionary
			} asArray
		} asDictionary.
	self assert: (domainObject isKindOf: GtLMethodsWithSource).
	self assert: domainObject methods size equals: 1.
	self assert: (domainObject methods first isKindOf: GtLMissingDomainObject).
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithEmptyMethodName [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodsSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> 'Collection'.
					'methodName' -> ''.
					'classSide' -> true} asDictionary
			} asArray
		} asDictionary.
	self assert: (domainObject isKindOf: GtLMethodsWithSource).
	self assert: domainObject methods size equals: 1.
	self assert: (domainObject methods first isKindOf: GtLMissingDomainObject).
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithNilDescriptor [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodsSource new.
	domainObject := self
		executeTool: tool
		withArguments: { 'methodDescriptors' -> { nil } asArray } asDictionary.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodDescriptors' 1) 
		errorMessage: '@[methodDescriptors/1] object expected'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithNilMethodClassName [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodsSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> nil.
					'methodName' -> 'withAll:'.
					'classSide' -> true} asDictionary
			} asArray
		} asDictionary.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodDescriptors' 1 'methodClassName') 
		errorMessage: '@[methodDescriptors/1/methodClassName] string expected'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithNilMethodName [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodsSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> 'Collection'.
					'methodName' -> nil.
					'classSide' -> true} asDictionary
			} asArray
		} asDictionary.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodDescriptors' 1 'methodName') 
		errorMessage: '@[methodDescriptors/1/methodName] string expected'.
	^ domainObject
]
