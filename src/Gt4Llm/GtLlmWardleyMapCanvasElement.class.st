Class {
	#name : #GtLlmWardleyMapCanvasElement,
	#superclass : #GtWardleyMapCanvasElement,
	#instVars : [
		'creator'
	],
	#category : #'Gt4Llm-Examples - Wardley Map'
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

{ #category : #accessing }
GtLlmWardleyMapCanvasElement >> installContextMenu [
	self
		addAptitude: ((BrGlamorousWithContextMenuAptitude
				handle: [ BlElement new
						size: 5 @ 5;
						geometry: BlEllipseGeometry new ]
				content: [ GtLlmWardleyMapEditorElement new
						canvas: self;
						creator: self creator;
						requestFocus ]) preferredExtent: 120 @ 150)
]
