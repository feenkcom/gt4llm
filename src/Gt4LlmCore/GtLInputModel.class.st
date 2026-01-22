Class {
	#name : #GtLInputModel,
	#superclass : #Object,
	#instVars : [
		'name',
		'model'
	],
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLInputModel >> addContentTo: aDictionary [
	self subclassResponsibility
]

{ #category : #adding }
GtLInputModel >> addInstructionsTo: aMessageInstructions [
	self subclassResponsibility
]

{ #category : #accessing }
GtLInputModel >> description [
	^ model gtDisplayString
]

{ #category : #'gt - inspector' }
GtLInputModel >> gtInspectorTargetModels [
	^ {self . model}
]

{ #category : #'gt - inspector' }
GtLInputModel >> gtViewContentDictionaryFor: aView [
	<gtView>
	^ aView forward
			title: 'Content Dictionary';
			object: [ 
				| content |
				content := OrderedDictionary new.
				self addContentTo: content.
				content ];
			view: #gtTreeFor:
]

{ #category : #accessing }
GtLInputModel >> model: anObject [ 
	model := anObject
]

{ #category : #accessing }
GtLInputModel >> name [
	^ name
]

{ #category : #accessing }
GtLInputModel >> name: aString [ 
	name := aString 
]
