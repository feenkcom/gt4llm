Class {
	#name : #GtLlmWardleyMapCanvasElement,
	#superclass : #GtWardleyMapCanvasElement,
	#instVars : [
		'creator'
	],
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmWardleyMapCanvasElement >> createNodeEditorFor: aNodeViewModel [
	^ GtLlmWardleyMapNodeEditorElement new
		creator: self creator;
		wardleyMapViewModel: self wardleyMapViewModel;
		wardleyMapNodeViewModel: aNodeViewModel
]

{ #category : #accessing }
GtLlmWardleyMapCanvasElement >> creator [
	^ creator
]

{ #category : #accessing }
GtLlmWardleyMapCanvasElement >> creator: anObject [
	creator := anObject
]
