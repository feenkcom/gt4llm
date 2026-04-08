Class {
	#name : #GtLMagritteToolForClassCommentChangeExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentForMissingClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassCommentChange new
		withArguments: {
			'classComment' -> 'Some comment'} asDictionary.

	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('className')
		path: #(nil)
		errorMessage: 'required properties missing [className]'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentForNilClassComment [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassCommentChange new
		withArguments: {
			'className' -> 'Object'. 'classComment' -> nil} asDictionary.

	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('classComment')
		errorMessage: '@[classComment] string expected'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentForNilClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassCommentChange new
		withArguments: {
			'className' -> nil. 
			'classComment' -> 'Some comment' } asDictionary.

	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('className')
		errorMessage: '@[className] string expected'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentMissingArgument [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassCommentChange new
		withArguments: { 
			'className' -> GtLMagritteToolForClassCommentChange name } asDictionary.

	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('classComment')
		path: #(nil)
		errorMessage: 'required properties missing [classComment]'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentSuccessful [
	<gtExample>
	| call className environment |
	
	environment := GtPharoDummiesGenerator withPackages: 1 classes: 1.
	className := environment anyDummyClass className.

	[ 
		| originalComment newComment targetObject |
		newComment := 'Updated example class comment'.
		originalComment := (Smalltalk globals at: className) comment.
		call := self
			executeTool: GtLMagritteToolForClassCommentChange new
			withArguments: {
				'className' -> className asString.
				'classComment' -> newComment} asDictionary.
		targetObject := call result targetObject.
	
		self assert: (targetObject isKindOf: GtLClassCommentChangeResult).
		self assert: targetObject changedClassName equals: className asString.
		self assert: targetObject status equals: 'changed'.
		self assert: targetObject oldClassComment equals: originalComment.
		self assert: targetObject newClassComment equals: newComment.
		self assert: (Smalltalk globals at: className) comment equals: newComment 
	]
		ensure: [ environment removeFromSystem ].
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassCommentChangeExamples >> changeCommentUnknownClass [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassCommentChange new
		withArguments: {
			'className' -> 'NonExistingClassName42'.
			'classComment' -> 'Some comment'
		} asDictionary.

	self
		assertMissingObject: call result targetObject
		withObjectName: 'NonExistingClassName42'
		errorMessage: 'NonExistingClassName42 is not found'.
	
	^ call
]

{ #category : #comment }
GtLMagritteToolForClassCommentChangeExamples >> comment [
	^ 'Examples for GtLMagritteToolForClassCommentChange.'
]
