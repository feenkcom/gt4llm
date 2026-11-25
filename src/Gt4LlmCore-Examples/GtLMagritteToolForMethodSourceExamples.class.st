Class {
	#name : #GtLMagritteToolForMethodSourceExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForClassSideTraitMethod [
	<gtExample>
	| call targetObject |
	call := self
			executeTool: GtLMagritteToolForMethodSource new
			withArguments: {'methodDescriptor'
						-> {'methodClassName' -> TGtLExampleTrait name asString.
								'methodName' -> 'classTraitMethod'.
								'classSide' -> true} asDictionary} asDictionary.
	targetObject := call result targetObject.

	self assert: (targetObject isKindOf: GtLMethodWithSource).
	self
		assert: targetObject methodReference methodClassName
		equals: TGtLExampleTrait name asString.
	self assert: targetObject methodReference isClassSide.
	self
		assert: targetObject sourceCode
		equals: (TGtLExampleTrait classSide >> #classTraitMethod) sourceCode.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForExistingClassSideMethod [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLMagritteToolForMethodSource new
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'Collection'.
				'methodName' -> 'withAll:'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodWithSource).
	self
		assert: targetObject sourceCode
		equals: (Collection class>>#withAll:) sourceCode.
	self
		assert: targetObject methodReference methodClassName
		sameContentAs: #Collection.
	self
		assert: targetObject methodReference methodName
		equals: 'withAll:'.
	self
		assert: targetObject methodReference classSide
		equals: true.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForExistingInstanceSideMethod [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLMagritteToolForMethodSource new
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'GtLMagritteToolForMethodSourceExamples'.
				'methodName' -> 'methodSourceForExistingInstanceSideMethod'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodWithSource).
	self
		assert: targetObject sourceCode
		equals: (GtLMagritteToolForMethodSourceExamples>>#methodSourceForExistingInstanceSideMethod) sourceCode.
	self
		assert: targetObject methodReference methodClassName
		sameContentAs: #GtLMagritteToolForMethodSourceExamples.
	self
		assert: targetObject methodReference methodName
		equals: 'methodSourceForExistingInstanceSideMethod'.
	self
		assert: targetObject methodReference classSide
		equals: false.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForInheritedClassSideMethod [
	<gtExample>
	| call targetObject expectedSignature definingReference |
	call := self
			executeTool: GtLMagritteToolForMethodSource new
			withArguments: {'methodDescriptor'
						-> {'methodClassName' -> 'GtLMagritteToolForMethodSourceExamples'.
								'methodName' -> 'new'.
								'classSide' -> true} asDictionary} asDictionary.
	targetObject := call result targetObject.
	expectedSignature := 'GtLMagritteToolForMethodSourceExamples class>>#new'.
	definingReference := GtLMethodReference
			fromCompiledMethod: (GtLMagritteToolForMethodSourceExamples class lookupSelector: #new).

	self
		assertMissingObject: targetObject
		withObjectName: expectedSignature
		errorMessage: expectedSignature
				, ' is not defined in its own class: it is inherited. Its source is '
				, definingReference methodSignature.
	self assert: (targetObject isKindOf: GtLMissingInheritedMethodDomainObject).
	self assert: targetObject definingMethodReference equals: definingReference.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForInheritedInstanceSideMethod [
	<gtExample>
	| call targetObject expectedSignature definingReference |
	call := self
			executeTool: GtLMagritteToolForMethodSource new
			withArguments: {'methodDescriptor'
						-> {'methodClassName' -> 'GtLMagritteToolForMethodSourceExamples'.
								'methodName' -> 'printString'.
								'classSide' -> false} asDictionary} asDictionary.
	targetObject := call result targetObject.
	expectedSignature := 'GtLMagritteToolForMethodSourceExamples>>#printString'.
	definingReference := GtLMethodReference
			fromCompiledMethod: (GtLMagritteToolForMethodSourceExamples lookupSelector: #printString).

	self
		assertMissingObject: targetObject
		withObjectName: expectedSignature
		errorMessage: expectedSignature
				, ' is not defined in its own class: it is inherited. Its source is '
				, definingReference methodSignature.
	self assert: (targetObject isKindOf: GtLMissingInheritedMethodDomainObject).
	self assert: targetObject definingMethodReference equals: definingReference.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingArguments [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodSource new
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('methodDescriptor') 
		path: #(nil) 
		errorMessage: 'required properties missing [methodDescriptor]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingClassSide [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodSource new
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'GtLMagritteToolForMethodSourceExamples'.
				'methodName' -> 'methodSourceForMissingClassSide'
			} asDictionary
		} asDictionary.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('classSide') 
		path: #('methodDescriptor') 
		errorMessage: '@[methodDescriptor] required properties missing [classSide]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingMethodClassName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodSource new
		withArguments: {
			'methodDescriptor' -> {
				'methodName' -> 'withAll:'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('methodClassName') 
		path: #('methodDescriptor') 
		errorMessage: '@[methodDescriptor] required properties missing [methodClassName]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForMissingMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodSource new
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'Collection'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('methodName') 
		path: #('methodDescriptor') 
		errorMessage: '@[methodDescriptor] required properties missing [methodName]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForTraitProvidedMethod [
	"The source of a method provided by a trait is not returned for the class that uses the trait"

	<gtExample>
	| call targetObject expectedSignature |
	call := self
			executeTool: GtLMagritteToolForMethodSource new
			withArguments: {'methodDescriptor'
						-> {'methodClassName' -> GtLExampleTraitUser name asString.
								'methodName' -> 'traitMethod'.
								'classSide' -> false} asDictionary} asDictionary.
	targetObject := call result targetObject.
	expectedSignature := GtLExampleTraitUser name asString , '>>#traitMethod'.

	self
		assertMissingObject: targetObject
		withObjectName: expectedSignature
		errorMessage: expectedSignature
				, ' is not defined in its own class: it is provided by a trait. Its source is '
				, TGtLExampleTrait name asString , '>>#traitMethod'.
	self assert: targetObject class equals: GtLMissingTraitMethodDomainObject.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForUnknownClass [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodSource new
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'ClassThatDoesNotExist'.
				'methodName' -> 'unknownSelector42'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self 
		assertMissingObject: call result targetObject 
		withObjectName: 'ClassThatDoesNotExist' 
		errorMessage: 'ClassThatDoesNotExist is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForUnknownClassSideMethod [
	<gtExample>
	| call expectedSignature |
	call := self
		executeTool: GtLMagritteToolForMethodSource new
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> GtLMagritteToolForMethodImplementors name.
				'methodName' -> 'unknownSelector42'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	expectedSignature := GtLMagritteToolForMethodImplementors name asString, ' class>>#unknownSelector42'.
	self 
		assertMissingObject: call result targetObject 
		withObjectName: expectedSignature 
		errorMessage: expectedSignature, ' is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceForUnknownInstanceSideMethod [
	<gtExample>
	| call expectedSignature |
	call := self
		executeTool: GtLMagritteToolForMethodSource new
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> GtLMagritteToolForMethodImplementors name.
				'methodName' -> 'unknownSelector42'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	expectedSignature := GtLMagritteToolForMethodImplementors name asString, '>>#unknownSelector42'.
	self 
		assertMissingObject: call result targetObject 
		withObjectName: expectedSignature 
		errorMessage: expectedSignature, ' is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithEmptyMethodClassName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodSource new
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> ''.
				'methodName' -> 'withAll:'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self assert: (call result targetObject isKindOf: GtLMissingDomainObject).
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithEmptyMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodSource new
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'Collection'.
				'methodName' -> ''.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self assert: (call result targetObject isKindOf: GtLMissingDomainObject).
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithNilDescriptor [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodSource new
		withArguments: { 'methodDescriptor' -> nil } asDictionary.
	self 
		assertJSONSchemaValidationError: call result targetObject 
		withPath: #('methodDescriptor') 
		errorMessage: '@[methodDescriptor] object expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithNilMethodClassName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodSource new
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> nil.
				'methodName' -> 'withAll:'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self 
		assertJSONSchemaValidationError: call result targetObject 
		withPath: #('methodDescriptor' 'methodClassName') 
		errorMessage: '@[methodDescriptor/methodClassName] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodSourceExamples >> methodSourceWithNilMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodSource new
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'Collection'.
				'methodName' -> nil.
				'classSide' -> true
			} asDictionary
		} asDictionary.
	self 
		assertJSONSchemaValidationError: call result targetObject 
		withPath: #('methodDescriptor' 'methodName') 
		errorMessage: '@[methodDescriptor/methodName] string expected'.
	^ call
]
