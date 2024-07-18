Class {
	#name : #GtLlmCodeReview,
	#superclass : #Object,
	#instVars : [
		'review'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtLlmCodeReview >> gtReviewFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Review';
		priority: 1;
		text: [ self review ];
		styler: (GtLlmMessageStyler new threadMessageViewModel: self)
]

{ #category : #accessing }
GtLlmCodeReview >> review [
	^ review
]

{ #category : #accessing }
GtLlmCodeReview >> review: anObject [
	review := anObject
]
