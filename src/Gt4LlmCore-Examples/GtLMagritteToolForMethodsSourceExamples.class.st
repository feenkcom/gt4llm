Class {
	#name : #GtLMagritteToolForMethodsSourceExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForExistingMethods [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLMagritteToolForMethodsSource new
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> 'Collection'.
					'methodName' -> 'withAll:'.
					'classSide' -> true} asDictionary.
				{'methodClassName' -> 'GtLMagritteToolForMethodsSourceExamples'.
					'methodName' -> 'methodSourcesForExistingMethods'.
					'classSide' -> false} asDictionary
			} asArray
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodsWithSource).
	self assert: targetObject methods size equals: 2.
	self
		assert: targetObject methods first sourceCode
		equals: (Collection class>>#withAll:) sourceCode.
	self
		assert: targetObject methods second sourceCode
		equals: (GtLMagritteToolForMethodsSourceExamples>>#methodSourcesForExistingMethods) sourceCode.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForInheritedMethod [
	<gtExample>
	| call targetObject |
	call := self
			executeTool: GtLMagritteToolForMethodsSource new
			withArguments: {'methodDescriptors'
						-> {{'methodClassName' -> 'GtLMagritteToolForMethodsSourceExamples'.
									'methodName' -> 'methodSourcesForInheritedMethod'.
									'classSide' -> false} asDictionary.
								{'methodClassName' -> 'GtLMagritteToolForMethodsSourceExamples'.
									'methodName' -> 'printString'.
									'classSide' -> false} asDictionary} asArray} asDictionary.
	targetObject := call result targetObject.

	self assert: (targetObject isKindOf: GtLMethodsWithSource).
	self assert: targetObject methods size equals: 2.
	self assert: (targetObject methods first isKindOf: GtLMethodWithSource).
	self
		assert: targetObject methods first sourceCode
		equals: (GtLMagritteToolForMethodsSourceExamples >> #methodSourcesForInheritedMethod)
				sourceCode.
	self
		assert: (targetObject methods second isKindOf: GtLMissingInheritedMethodDomainObject).
	self
		assert: targetObject methods second definingMethodReference
		equals: (GtLMethodReference
				fromCompiledMethod: (GtLMagritteToolForMethodsSourceExamples lookupSelector: #printString)).
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForMissingArguments [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodsSource new
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('methodDescriptors') 
		path: #(nil) 
		errorMessage: 'required properties missing [methodDescriptors]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForMissingMethodArguments [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodsSource new
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
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('methodName') 
		path: #('methodDescriptors' 1) 
		errorMessage: '@[methodDescriptors/1] required properties missing [methodName]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForTraitProvidedMethod [
	<gtExample>
	| call targetObject |
	call := self
			executeTool: GtLMagritteToolForMethodsSource new
			withArguments: {'methodDescriptors'
						-> {{'methodClassName' -> TGtLExampleTrait name asString.
									'methodName' -> 'traitMethod'.
									'classSide' -> false} asDictionary.
								{'methodClassName' -> GtLExampleTraitUser name asString.
									'methodName' -> 'aliasedTraitMethod'.
									'classSide' -> false} asDictionary} asArray} asDictionary.
	targetObject := call result targetObject.

	self assert: (targetObject isKindOf: GtLMethodsWithSource).
	self assert: targetObject methods size equals: 2.
	self assert: (targetObject methods first isKindOf: GtLMethodWithSource).
	self
		assert: targetObject methods first sourceCode
		equals: (TGtLExampleTrait >> #traitMethod) sourceCode.
	self
		assert: targetObject methods second class
		equals: GtLMissingTraitMethodDomainObject.
	self
		assert: targetObject methods second definingMethodReference
		equals: targetObject methods first methodReference.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForUnknownClass [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodsSource new
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
	self assert: (call result targetObject isKindOf: GtLMethodsWithSource).
	self assert: call result targetObject methods size equals: 2.
	self assert: call result targetObject methods first isErrorDomainObject.
	self assert: (call result targetObject methods second isKindOf: GtLMethodWithSource).
	self assert: call result targetObject methods first objectName equals: 'ClassThatDoesNotExist'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesForUnknownMethod [
	<gtExample>
	| call expectedSignature |
	call := self
		executeTool: GtLMagritteToolForMethodsSource new
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
	self assert: (call result targetObject isKindOf: GtLMethodsWithSource).
	self assert: call result targetObject methods size equals: 2.
	self assert: call result targetObject methods first isErrorDomainObject.
	self assert: (call result targetObject methods second isKindOf: GtLMethodWithSource).
	expectedSignature := GtLMagritteToolForMethodImplementors name asString, '>>#unknownSelector42'.
	self assert: call result targetObject methods first objectName equals: expectedSignature.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithEmptyMethodClassName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodsSource new
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> ''.
					'methodName' -> 'withAll:'.
					'classSide' -> true} asDictionary
			} asArray
		} asDictionary.
	self assert: (call result targetObject isKindOf: GtLMethodsWithSource).
	self assert: call result targetObject methods size equals: 1.
	self assert: (call result targetObject methods first isKindOf: GtLMissingDomainObject).
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithEmptyMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodsSource new
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> 'Collection'.
					'methodName' -> ''.
					'classSide' -> true} asDictionary
			} asArray
		} asDictionary.
	self assert: (call result targetObject isKindOf: GtLMethodsWithSource).
	self assert: call result targetObject methods size equals: 1.
	self assert: (call result targetObject methods first isKindOf: GtLMissingDomainObject).
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithNilDescriptor [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodsSource new
		withArguments: { 'methodDescriptors' -> { nil } asArray } asDictionary.
	self 
		assertJSONSchemaValidationError: call result targetObject 
		withPath: #('methodDescriptors' 1) 
		errorMessage: '@[methodDescriptors/1] object expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithNilMethodClassName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodsSource new
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> nil.
					'methodName' -> 'withAll:'.
					'classSide' -> true} asDictionary
			} asArray
		} asDictionary.
	self 
		assertJSONSchemaValidationError: call result targetObject 
		withPath: #('methodDescriptors' 1 'methodClassName') 
		errorMessage: '@[methodDescriptors/1/methodClassName] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsSourceExamples >> methodSourcesWithNilMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodsSource new
		withArguments: {
			'methodDescriptors' -> {
				{'methodClassName' -> 'Collection'.
					'methodName' -> nil.
					'classSide' -> true} asDictionary
			} asArray
		} asDictionary.
	self 
		assertJSONSchemaValidationError: call result targetObject 
		withPath: #('methodDescriptors' 1 'methodName') 
		errorMessage: '@[methodDescriptors/1/methodName] string expected'.
	^ call
]
