Class {
	#name : #GtLUserMessageContentExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'as yet unclassified' }
GtLUserMessageContentExamples >> basicUserMessage [
	^ GtLAnthropicUserMessage new
]

{ #category : #'as yet unclassified' }
GtLUserMessageContentExamples >> createUserMessageWithMarkdownInputObject [
	<gtExample>
	| userMessage |
	userMessage := self basicUserMessage 
			markdown: 'How are you'.
			
	^userMessage
]
