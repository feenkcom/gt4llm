Class {
	#name : #GtLChatWithOpenAIProviderStubExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-OpenAI-Examples'
}

{ #category : #'as yet unclassified' }
GtLChatWithOpenAIProviderStubExamples >> chatWithInstructions [
	<gtExample>
	| chat message instructions |
	chat := self chatWithOpenAIProviderStub.
	chat addInstructionSectionForLepiterPages: {'Examples by example'} titled: 'Explanations'.
	message := chat createUserMessage.
	message chat: chat.
	instructions := message completeInstructionString.
	self assert: (instructions includesSubstring: 'Examples by example').
	^ message
]

{ #category : #'as yet unclassified' }
GtLChatWithOpenAIProviderStubExamples >> chatWithOpenAIProviderStub [
	<gtExample>
	| chat |
	chat := GtLChat new.
	chat provider: GtLOpenAIProviderStub new.
	^ chat
]

{ #category : #'as yet unclassified' }
GtLChatWithOpenAIProviderStubExamples >> chatWithResponseFormat [
	<gtExample>
	| chat message |
	chat := self chatWithOpenAIProviderStub.
	chat markdownResponse.
	message := chat createUserMessage.
	message chat: chat.
	self assert: message formatDescriptions size = 1.
	^ message
]

{ #category : #'as yet unclassified' }
GtLChatWithOpenAIProviderStubExamples >> chatWithTools [
	<gtExample>
	| chat message tool |
	chat := self chatWithOpenAIProviderStub.
	tool := GtLToolForClassLookup new.
	chat tools: {tool}.
	message := chat createUserMessage.
	message chat: chat.
	self assert: message tools size = 1.
	self assert: message tools anyOne = tool.
	^ message
]

{ #category : #'as yet unclassified' }
GtLChatWithOpenAIProviderStubExamples >> messageWithInstructions [
	<gtExample>
	| chat message instructions |
	chat := self chatWithOpenAIProviderStub.
	message := chat createUserMessage.
	instructions := message completeInstructionString.
	self assert: instructions isEmpty.
	message addInstructionSectionForLepiterPages: {'Examples by example'} titled: 'Explanations'.
	instructions := message completeInstructionString.
	self assert: instructions notEmpty.
	^ message
]

{ #category : #'as yet unclassified' }
GtLChatWithOpenAIProviderStubExamples >> userMessage [
	<gtExample>
	| chat message |
	chat := self chatWithOpenAIProviderStub.
	message := chat createUserMessage.
	self assert: message isUserRole.
	self assert: message formatDescriptions size = 0.
	self assert: message tools size = 0.
	self assert: message instructions isEmpty.
	self assert: message inputModels size = 0.
	^ message
]
