Class {
	#name : #GtLlmWardleyMapEditorElement,
	#superclass : #GtWardleyMapEditorElement,
	#instVars : [
		'creator'
	],
	#category : #'Gt4Llm-Domain - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapEditorElement >> creator [
	^ creator
]

{ #category : #accessing }
GtLlmWardleyMapEditorElement >> creator: anObject [
	creator := anObject.
	
	self onCreatorUpdated
]

{ #category : #accessing }
GtLlmWardleyMapEditorElement >> onCreatorUpdated [
	
]
