"
Examples for GtLMagritteToolForClassCreation.
"
Class {
	#name : #GtLMagritteToolForClassCreationExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassThatAlreadyExists [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassCreation new
		withArguments: {
			'classCreationRequest' -> {
				'targetClassName' -> #Object.
				'superclassName' -> #Object.
				'package' -> 'Gt4LlmCoreNewPackage'
			} asDictionary
		} asDictionary.
	
	self
		assertUnexpectedObject: call result targetObject
		withObjectName: 'Object'
		errorMessage: 'Object already exists'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithComment [
	<gtExample>
	| className comment call |
	
	className := #GtLMagritteToolForClassCreationExamplesGeneratedWithComment.
	comment := 'Example class comment'.
	self removeClassNamedIfPresent: className.
	[
		| createdClass targetObject |
		call := self
			executeTool: GtLMagritteToolForClassCreation new
			withArguments: {
				'classCreationRequest' -> {
					'targetClassName' -> className.
					'superclassName' -> #Object.
					'package' -> 'Gt4LlmCoreNewPackage'.
					'comment' -> comment
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		
		self assert: (targetObject isKindOf: GtLClassModificationResult).
		createdClass := Smalltalk globals at: className ifAbsent: [ nil ].
		self assert: createdClass notNil.
		self assert: createdClass comment equals: comment.
		self assert: targetObject comment equals: comment
	] ensure: [
		self removeClassNamedIfPresent: className
	].
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithInstanceVariables [
	<gtExample>
	| className call |
	
	className := #GtLMagritteToolForClassCreationExamplesGenerated1.
	self removeClassNamedIfPresent: className.
	[
		| createdClass targetObject |
		call := self
			executeTool: GtLMagritteToolForClassCreation new
			withArguments: {
				'classCreationRequest' -> {
					'targetClassName' -> className.
					'superclassName' -> #Object.
					'instanceVariables' -> 'firstSlot secondSlot'.
					'package' -> 'Gt4LlmCoreNewPackage'
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		
		self assert: (targetObject isKindOf: GtLClassModificationResult).
		createdClass := Smalltalk globals at: className ifAbsent: [ nil ].
		self assert: createdClass notNil.
		self assert: (createdClass instanceVariables collect: #name) equals: #('firstSlot' 'secondSlot').
		self assert: targetObject currentClassName equals: className asString.
		self assert: targetObject superclassName equals: 'Object'.
		self assert: targetObject packageName equals: 'Gt4LlmCoreNewPackage'.
		self assert: targetObject instanceSlotNames asArray equals: #('firstSlot' 'secondSlot')
	] ensure: [
		self removeClassNamedIfPresent: className
	].
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithMissingArguments [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassCreation new
		withArguments: Dictionary new.
	
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('classCreationRequest')
		path: #(nil)
		errorMessage: 'required properties missing [classCreationRequest]'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithMissingTargetClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassCreation new
		withArguments: {
			'classCreationRequest' -> {
				'superclassName' -> #Object.
				'package' -> 'Gt4LlmCoreNewPackage'
			} asDictionary
		} asDictionary.
	
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('targetClassName')
		path: #('classCreationRequest')
		errorMessage: '@[classCreationRequest] required properties missing [targetClassName]'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithNilClassCreationRequest [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassCreation new
		withArguments: {
			'classCreationRequest' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('classCreationRequest')
		errorMessage: '@[classCreationRequest] object expected'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithNilClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassCreation new
		withArguments: {
			'classCreationRequest' -> {
				'targetClassName' -> nil.
				'superclassName' -> #Object.
				'package' -> 'Gt4LlmCoreNewPackage'
			} asDictionary
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #(#classCreationRequest #targetClassName)
		errorMessage: '@[classCreationRequest/targetClassName] string expected'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithNilPackage [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassCreation new
		withArguments: {
			'classCreationRequest' -> {
				'targetClassName' -> #TestClassName.
				'superclassName' -> #Object.
				'package' -> nil
			} asDictionary
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #(#classCreationRequest #package)
		errorMessage: '@[classCreationRequest/package] string expected'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithNilSuperclass [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassCreation new
		withArguments: {
			'classCreationRequest' -> {
				'targetClassName' -> #TestClassName.
				'superclassName' -> nil.
				'package' -> 'Gt4LlmCoreNewPackage'
			} asDictionary
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #(#classCreationRequest #superclassName)
		errorMessage: '@[classCreationRequest/superclassName] string expected'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithUnknownSuperclass [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassCreation new
		withArguments: {
			'classCreationRequest' -> {
				'targetClassName' -> #GtLMagritteToolForClassCreationExamplesUnknownSuperclass.
				'superclassName' -> 'ClassThatDoesNotExistForClassCreation'.
				'package' -> 'Gt4LlmCoreNewPackage'
			} asDictionary
		} asDictionary.
	
	self
		assertMissingObject: call result targetObject
		withObjectName: 'ClassThatDoesNotExistForClassCreation'
		errorMessage: 'ClassThatDoesNotExistForClassCreation is not found'.
		
	^ call
]

{ #category : #private }
GtLMagritteToolForClassCreationExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]
