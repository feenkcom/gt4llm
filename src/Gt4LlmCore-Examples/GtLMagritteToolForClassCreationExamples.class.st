"
Examples for GtLMagritteToolForClassCreation.
"
Class {
	#name : #GtLMagritteToolForClassCreationExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassThatAlreadyExists [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classCreationRequest' -> {
			'targetClassName' -> #Object.
			'superclassName' -> #Object.
			'package' -> 'Gt4LlmCoreNewPackage'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertUnexpectedObject: targetObject
		withObjectName: 'Object'
		errorMessage: 'Object already exists'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithComment [
	<gtExample>
	| className comment |
	className := #GtLMagritteToolForClassCreationExamplesGeneratedWithComment.
	comment := 'Example class comment'.
	self removeClassNamedIfPresent: className.
	[
		| tool call result targetObject createdClass |
		tool := GtLMagritteToolForClassCreation new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'classCreationRequest' -> {
				'targetClassName' -> className.
				'superclassName' -> #Object.
				'package' -> 'Gt4LlmCoreNewPackage'.
				'comment' -> comment
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		
		targetObject := result targetObject.
		self assert: (targetObject isKindOf: GtLClassModificationResult).
		createdClass := Smalltalk globals at: className ifAbsent: [ nil ].
		self assert: createdClass notNil.
		self assert: createdClass comment equals: comment.
		self assert: targetObject comment equals: comment.
		call
	] ensure: [
		self removeClassNamedIfPresent: className
	]
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithInstanceVariables [
	<gtExample>
	| className |
	className := #GtLMagritteToolForClassCreationExamplesGenerated1.
	self removeClassNamedIfPresent: className.
	[
		| tool call result targetObject createdClass |
		tool := GtLMagritteToolForClassCreation new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'classCreationRequest' -> {
				'targetClassName' -> className.
				'superclassName' -> #Object.
				'instanceVariables' -> 'firstSlot secondSlot'.
				'package' -> 'Gt4LlmCoreNewPackage'
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		
		targetObject := result targetObject.
		self assert: (targetObject isKindOf: GtLClassModificationResult).
		createdClass := Smalltalk globals at: className ifAbsent: [ nil ].
		self assert: createdClass notNil.
		self assert: (createdClass instanceVariables collect: #name) equals: #('firstSlot' 'secondSlot').
		self assert: targetObject currentClassName equals: className asString.
		self assert: targetObject superclassName equals: 'Object'.
		self assert: targetObject packageName equals: 'Gt4LlmCoreNewPackage'.
		self assert: targetObject instanceSlotNames asArray equals: #('firstSlot' 'secondSlot').
		call
	] ensure: [
		self removeClassNamedIfPresent: className
	]
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithMissingArguments [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('classCreationRequest')
		path: #(nil)
		errorMessage: 'required properties missing [classCreationRequest]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithMissingTargetClassName [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classCreationRequest' -> {
			'superclassName' -> #Object.
			'package' -> 'Gt4LlmCoreNewPackage'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('targetClassName')
		path: #('classCreationRequest')
		errorMessage: '@[classCreationRequest] required properties missing [targetClassName]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithNilClassCreationRequest [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classCreationRequest' -> nil
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('classCreationRequest')
		errorMessage: '@[classCreationRequest] object expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithNilClassName [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classCreationRequest' -> {
			'targetClassName' -> nil.
			'superclassName' -> #Object.
			'package' -> 'Gt4LlmCoreNewPackage'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #(#classCreationRequest #targetClassName)
		errorMessage: '@[classCreationRequest/targetClassName] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithNilPackage [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classCreationRequest' -> {
			'targetClassName' -> #TestClassName.
			'superclassName' -> #Object.
			'package' -> nil
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #(#classCreationRequest #package)
		errorMessage: '@[classCreationRequest/package] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithNilSuperclass [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classCreationRequest' -> {
			'targetClassName' -> #TestClassName.
			'superclassName' -> nil.
			'package' -> 'Gt4LlmCoreNewPackage'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #(#classCreationRequest #superclassName)
		errorMessage: '@[classCreationRequest/superclassName] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCreationExamples >> createClassWithUnknownSuperclass [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassCreation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classCreationRequest' -> {
			'targetClassName' -> #GtLMagritteToolForClassCreationExamplesUnknownSuperclass.
			'superclassName' -> 'ClassThatDoesNotExistForClassCreation'.
			'package' -> 'Gt4LlmCoreNewPackage'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingObject: targetObject
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
