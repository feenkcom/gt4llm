Class {
	#name : #GtLMagritteToolForMethodSourceExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForExistingClassSideMethod [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'Collection'.
				'methodName' -> 'withAll:'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self assert: (domainObject isKindOf: GtLMethodWithSource).
	self
		assert: domainObject sourceCode
		equals: (Collection class>>#withAll:) sourceCode.
	self
		assert: domainObject methodReference methodClassName
		equals: #Collection.
	self
		assert: domainObject methodReference methodName
		equals: 'withAll:'.
	self
		assert: domainObject methodReference classSide
		equals: true.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForExistingInstanceSideMethod [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> #GtLMagritteToolForMethodSourceExamples.
				'methodName' -> 'methodSourceForExistingInstanceSideMethod'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	self assert: (domainObject isKindOf: GtLMethodWithSource).
	self
		assert: domainObject sourceCode
		equals: (GtLMagritteToolForMethodSourceExamples>>#methodSourceForExistingInstanceSideMethod) sourceCode.
	self
		assert: domainObject methodReference methodClassName
		equals: #GtLMagritteToolForMethodSourceExamples.
	self
		assert: domainObject methodReference methodName
		equals: 'methodSourceForExistingInstanceSideMethod'.
	self
		assert: domainObject methodReference classSide
		equals: false.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingArguments [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodSource new.
	domainObject := self
		executeTool: tool
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methodDescriptor') 
		path: #(nil) 
		errorMessage: 'required properties missing [methodDescriptor]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingClassSide [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'GtLMagritteToolForMethodSourceExamples'.
				'methodName' -> 'methodSourceForMissingClassSide'
			} asDictionary
		} asDictionary.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('classSide') 
		path: #(#methodDescriptor) 
		errorMessage: '@[methodDescriptor] required properties missing [classSide]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingMethodClassName [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptor' -> {
				'methodName' -> 'withAll:'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methodClassName') 
		path: #(#methodDescriptor) 
		errorMessage: '@[methodDescriptor] required properties missing [methodClassName]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingMethodName [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'Collection'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methodName') 
		path: #(#methodDescriptor) 
		errorMessage: '@[methodDescriptor] required properties missing [methodName]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForUnknownClass [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'ClassThatDoesNotExist'.
				'methodName' -> 'unknownSelector42'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self 
		assertMissingObject: domainObject 
		withObjectName: 'ClassThatDoesNotExist' 
		errorMessage: 'ClassThatDoesNotExist is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForUnknownClassSideMethod [
	<gtExample>
	| tool domainObject expectedSignature |
	tool := GtLMagritteToolForMethodSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> GtLMagritteToolForMethodImplementors name.
				'methodName' -> 'unknownSelector42'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	expectedSignature := GtLMagritteToolForMethodImplementors name, ' class>>#unknownSelector42'.
	self 
		assertMissingObject: domainObject 
		withObjectName: expectedSignature 
		errorMessage: expectedSignature, ' is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForUnknownInstanceSideMethod [
	<gtExample>
	| tool domainObject expectedSignature |
	tool := GtLMagritteToolForMethodSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> GtLMagritteToolForMethodImplementors name.
				'methodName' -> 'unknownSelector42'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	expectedSignature := GtLMagritteToolForMethodImplementors name, '>>#unknownSelector42'.
	self 
		assertMissingObject: domainObject 
		withObjectName: expectedSignature 
		errorMessage: expectedSignature, ' is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithEmptyMethodClassName [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> ''.
				'methodName' -> 'withAll:'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self assert: (domainObject isKindOf: GtLMissingDomainObject).
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithEmptyMethodName [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'Collection'.
				'methodName' -> ''.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self assert: (domainObject isKindOf: GtLMissingDomainObject).
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithNilDescriptor [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodSource new.
	domainObject := self
		executeTool: tool
		withArguments: { 'methodDescriptor' -> nil } asDictionary.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodDescriptor') 
		errorMessage: '@[methodDescriptor] object expected'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithNilMethodClassName [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> nil.
				'methodName' -> 'withAll:'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodDescriptor' 'methodClassName') 
		errorMessage: '@[methodDescriptor/methodClassName] string expected'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithNilMethodName [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodSource new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'Collection'.
				'methodName' -> nil.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodDescriptor' 'methodName') 
		errorMessage: '@[methodDescriptor/methodName] string expected'.
	^ domainObject
]
