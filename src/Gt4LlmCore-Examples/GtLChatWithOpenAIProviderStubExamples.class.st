Class {
	#name : #GtLChatWithOpenAIProviderStubExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLChatWithOpenAIProviderStubExamples >> chatWithInstructions [
	<gtExample>
	| chat message instructions |
	chat := self chatWithOpenAIProviderStub.
	chat addInstructionSectionForLepiterPages: {'Examples by example'} titled: 'Explanations'.
	message := chat createUserMessage.
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
	self assert: message formatDescriptions size = 1.
	^ message
]

{ #category : #'as yet unclassified' }
GtLChatWithOpenAIProviderStubExamples >> chatWithTools [
	<gtExample>
	| chat message tools |
	chat := self chatWithOpenAIProviderStub.
	tools := {GtLToolForClassLookup new}.
	chat tools: tools.
	message := chat createUserMessage.
	self assert: message tools = tools.
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
