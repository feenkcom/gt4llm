Class {
	#name : #GtOpenAIToolsGroup,
	#superclass : #GtOpenAIGroup,
	#category : #'Gt4OpenAI-Examples'
}

{ #category : #accessing }
GtOpenAIToolsGroup >> serialize [
	^ Character cr join: (self items collect: [ :aTool | '- ' , aTool serialize ])
]
