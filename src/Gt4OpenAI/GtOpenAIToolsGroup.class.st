Class {
	#name : #GtOpenAIToolsGroup,
	#superclass : #GtOpenAIGroup,
	#category : #'Gt4OpenAI-Groups'
}

{ #category : #accessing }
GtOpenAIToolsGroup >> serialize [
	^ Character cr join: (self items collect: [ :aTool | '- ' , aTool serialize ])
]
