Class {
	#name : #GtLlmMessageExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Gt4Llm-Examples'
}

{ #category : #'as yet unclassified' }
GtLlmMessageExamples >> assistantMessage [
	<gtExample>
	^ GtLlmAssistantMessage new content: 'This is an assistant message'
]

{ #category : #'as yet unclassified' }
GtLlmMessageExamples >> systemMessage [
	<gtExample>
	^ GtLlmSystemMessage new content: 'This is a system message'
]

{ #category : #'as yet unclassified' }
GtLlmMessageExamples >> userMessage [
	<gtExample>
	^ GtLlmUserMessage new content: 'This is a user message'
]
