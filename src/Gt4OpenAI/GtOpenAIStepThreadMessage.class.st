Class {
	#name : #GtOpenAIStepThreadMessage,
	#superclass : #GtOpenAIThreadMessage,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIStepThreadMessage >> asViewModel [
	^ GtLlmStepThreadMessageViewModel new threadMessage: self
]

{ #category : #accessing }
GtOpenAIStepThreadMessage >> elementClass [
	^ GtLlmExpandableThreadMessageElement
]

{ #category : #accessing }
GtOpenAIStepThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ GtLlmStepThreadMessageElement new threadMessageViewModel: self asViewModel ]
]
