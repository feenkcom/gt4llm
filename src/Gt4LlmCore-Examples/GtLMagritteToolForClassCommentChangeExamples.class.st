Class {
	#name : #GtLMagritteToolForClassCommentChangeExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentMissingArgument [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassCommentChange new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'className' -> GtLMagritteToolForClassCommentChange name } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model class equals: GtLMissingRequiredPropertiesDomainObject.
	self assert: model missingPropertyNames equals: #('classComment').
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentSuccessful [
	<gtExample>
	| tool call result model className originalComment newComment environment |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLClassCommentChangeResult).
	self assert: model className equals: className asString.
	self assert: model status equals: 'changed'.
	self assert: model oldClassComment equals: originalComment.
	self assert: model newClassComment equals: newComment.
	self assert: (Smalltalk globals at: className) comment equals: newComment ]
		ensure: [ environment removeFromSystem ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentUnknownClass [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassCommentChange new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'className' -> 'NonExistingClassName42'.
		'classComment' -> 'Some comment'
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingDomainObject).
	self assert: model objectName equals: 'NonExistingClassName42'.
	^ call
]

{ #category : #accessing }
GtLMagritteToolForClassCommentChangeExamples >> comment [
	^ 'Examples for GtLMagritteToolForClassCommentChange.'
]
