Class {
	#name : #GtLlmMessageExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmMessageExamples >> actionMessage [
	<gtExample>
	| anActionMessage |
	anActionMessage := GtLlmActionMessage new
		role: 'assistant';
		content: '{''Action'': ''An Action''}'.
		
	self assert: anActionMessage action equals: 'An Action'.
	
	^ anActionMessage
]

{ #category : #'as yet unclassified' }
GtLlmMessageExamples >> assistantMessage [
	<gtExample>
	^ GtLlmAssistantMessage new content: 'This is an assistant message'
]

{ #category : #'as yet unclassified' }
GtLlmMessageExamples >> parsedMessage [
	<gtExample>
	| anAssistantMessage |
	anAssistantMessage := GtLlmChatMessage
		from: {'role' -> 'assistant'.
				'content' -> 'This is an assistant message'} asDictionary.
				
	self assert: anAssistantMessage isAssistantRole.
	self assert: anAssistantMessage content equals: 'This is an assistant message'.
	
	^ anAssistantMessage
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
