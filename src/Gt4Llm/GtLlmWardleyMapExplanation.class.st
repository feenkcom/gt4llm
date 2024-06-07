Class {
	#name : #GtLlmWardleyMapExplanation,
	#superclass : #Object,
	#instVars : [
		'explanation'
	],
	#category : #'Gt4Llm-Examples - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapExplanation >> explanation [
	^ explanation
]

{ #category : #accessing }
GtLlmWardleyMapExplanation >> explanation: anObject [
	explanation := anObject
]

{ #category : #accessing }
GtLlmWardleyMapExplanation >> gtExplanationFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Explanation';
		priority: 1;
		text: [ self explanation ];
		styler: (GtLlmMessageStyler new threadMessageViewModel: self)
]
