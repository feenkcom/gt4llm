Class {
	#name : #GtLlmWardleyMapElement,
	#superclass : #GtWardleyMapElement,
	#instVars : [
		'creator'
	],
	#category : #'Gt4Llm-Domain - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapElement >> createCanvasElement [
	^ GtLlmWardleyMapCanvasElement new creator: self creator
]

{ #category : #accessing }
GtLlmWardleyMapElement >> creator [
	^ creator
]

{ #category : #accessing }
GtLlmWardleyMapElement >> creator: anObject [
	creator := anObject.
	canvasElement creator: anObject
]
