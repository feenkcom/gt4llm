Class {
	#name : #GtLMagritteToolForClassCommentChangeExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentForMissingClassName [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassCommentChange new.
	call := GtLFunctionToolCall new.
	call rawArguments: {'classComment' -> 'Some comment'} asDictionary.
	result := tool performToolCall: call.

	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).

	targetObject := result targetObject.
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('className')
		path: #(nil)
		errorMessage: 'required properties missing [className]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentForNilClassComment [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassCommentChange new.
	call := GtLFunctionToolCall new.
	call rawArguments: {'className' -> 'Object'. 'classComment' -> nil} asDictionary.
	result := tool performToolCall: call.

	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).

	targetObject := result targetObject.
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('classComment')
		errorMessage: '@[classComment] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentForNilClassName [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassCommentChange new.
	call := GtLFunctionToolCall new.
	call rawArguments: {'className' -> nil. 'classComment' -> 'Some comment'} asDictionary.
	result := tool performToolCall: call.

	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).

	targetObject := result targetObject.
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('className')
		errorMessage: '@[className] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentMissingArgument [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassCommentChange new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> GtLMagritteToolForClassCommentChange name } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('classComment')
		path: #(nil)
		errorMessage: 'required properties missing [classComment]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentSuccessful [
	<gtExample>
	| tool call result targetObject className originalComment newComment environment |
	environment := GtPharoDummiesGenerator withPackages: 1 classes: 1.
	className := environment anyDummyClass className.

	[ newComment := 'Updated example class comment'.
	originalComment := (Smalltalk globals at: className) comment.
	tool := GtLMagritteToolForClassCommentChange new.
	call := GtLFunctionToolCall new.
	call
		rawArguments: {'className' -> className asString.
				'classComment' -> newComment} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLClassCommentChangeResult).
	self assert: targetObject changedClassName equals: className asString.
	self assert: targetObject status equals: 'changed'.
	self assert: targetObject oldClassComment equals: originalComment.
	self assert: targetObject newClassComment equals: newComment.
	self assert: (Smalltalk globals at: className) comment equals: newComment ]
		ensure: [ environment removeFromSystem ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentUnknownClass [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassCommentChange new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'className' -> 'NonExistingClassName42'.
		'classComment' -> 'Some comment'
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingObject: targetObject
		withObjectName: 'NonExistingClassName42'
		errorMessage: 'NonExistingClassName42 is not found'.
	^ call
]

{ #category : #comment }
GtLMagritteToolForClassCommentChangeExamples >> comment [
	^ 'Examples for GtLMagritteToolForClassCommentChange.'
]
