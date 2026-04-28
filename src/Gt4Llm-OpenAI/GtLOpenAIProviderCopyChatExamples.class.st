Class {
	#name : #GtLOpenAIProviderCopyChatExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #asserting }
GtLOpenAIProviderCopyChatExamples >> assertCopiedChatMessage: aCopiedMessage isCopyOf: anOriginalMessage forChat: aChat [
	self assert: aCopiedMessage ~~ anOriginalMessage.
	self assert: aCopiedMessage class equals: anOriginalMessage class.
	self assert: aCopiedMessage chat == aChat.
	self assert: aCopiedMessage announcer ~~ anOriginalMessage announcer.
	self assert: aCopiedMessage formatDescriptions ~~ anOriginalMessage formatDescriptions.
	self assert: aCopiedMessage tools ~~ anOriginalMessage tools.
]

{ #category : #asserting }
GtLOpenAIProviderCopyChatExamples >> assertCopiedReplyMessage: aCopiedReply isCopyOf: anOriginalReply forChat: aChat [
	self assertCopiedChatMessage: aCopiedReply isCopyOf: anOriginalReply forChat: aChat.
	self assert: aCopiedReply userMessage ~~ anOriginalReply userMessage.
	self assert: aCopiedReply finalMessage ~~ anOriginalReply finalMessage.
	self assert: aCopiedReply executionMessages size equals: anOriginalReply executionMessages size.
	self assert: (aCopiedReply executionMessages allSatisfy: [ :each | each chat == aChat ]).
	self assertCopiedChatMessage: aCopiedReply userMessage isCopyOf: anOriginalReply userMessage forChat: aChat.
	self assertCopiedChatMessage: aCopiedReply finalMessage isCopyOf: anOriginalReply finalMessage forChat: aChat.
]

{ #category : #examples }
GtLOpenAIProviderCopyChatExamples >> chatWithTwoMessages [
	<gtExample>
	<return: #GtLChat>
	| chat userMessage assistantMessage messages |
	
	chat := GtLChat new.
	chat provider: GtLOpenAIProvider new.
	
	userMessage := chat createUserMessage.
	userMessage string: 'Hello'.
	chat addUserMessage: userMessage.
	
	assistantMessage := GtLOpenAIAssistantMessage new.
	assistantMessage rawData: { 'content' -> { { 'text' -> 'Hi there' } asDictionary } } asDictionary.
	chat addAssistantMessage: assistantMessage.
	messages := chat messages asArray.
	
	self assert: messages size equals: 2.
	self assert: (messages first chat == chat).
	self assert: (messages second chat == chat).
	self assert: (messages second userMessage == userMessage).
	self assert: (messages second finalMessage == assistantMessage).
	
	^ chat
]

{ #category : #examples }
GtLOpenAIProviderCopyChatExamples >> copyChatWithTwoMessages [
	<gtExample>
	<return: #GtLChat>
	| originalChat copiedChat originalMessages copiedMessages |
	
	originalChat := self chatWithTwoMessages.
	copiedChat := originalChat copyForIndependentRequest.
	
	originalMessages := originalChat messages asArray.
	copiedMessages := copiedChat messages asArray.
	
	self assert: copiedChat ~~ originalChat.
	self assert: copiedMessages size equals: originalMessages size.
	self assert: (copiedMessages allSatisfy: [ :each | each chat == copiedChat ]).
	self assert: (copiedMessages first ~~ originalMessages first).
	self assert: (copiedMessages second ~~ originalMessages second).
	
	self assert: (copiedMessages second userMessage ~~ originalMessages second userMessage).
	self assert: (copiedMessages second finalMessage ~~ originalMessages second finalMessage).

	self assert: copiedMessages second userMessage chat == copiedChat.
	self assert: copiedMessages second finalMessage chat == copiedChat.
	
	^ copiedChat
]

{ #category : #examples }
GtLOpenAIProviderCopyChatExamples >> copyOpenAIAssistantMessage [
	<gtExample>
	<return: #GtLOpenAIAssistantMessage>
	| originalChat newChat assistantMessage copiedAssistant |
	
	originalChat := GtLChat new.
	originalChat provider: GtLOpenAIProvider new.
	
	newChat := GtLChat new.
	newChat provider: GtLOpenAIProvider new.
	
	assistantMessage := GtLOpenAIAssistantMessage new.
	assistantMessage rawData: { 'content' -> { { 'text' -> 'Assistant' } asDictionary } } asDictionary.
	assistantMessage chat: originalChat.
	copiedAssistant := assistantMessage copyForIndependentRequestInChat: newChat.
	
	self assertCopiedChatMessage: copiedAssistant isCopyOf: assistantMessage forChat: newChat.
	self assert: assistantMessage chat == originalChat.
	
	^ copiedAssistant
]

{ #category : #examples }
GtLOpenAIProviderCopyChatExamples >> copyOpenAICompactionMessage [
	<gtExample>
	<return: #GtLOpenAICompactionMessage>
	| originalChat newChat compactionMessage copiedCompaction |
	
	originalChat := GtLChat new.
	originalChat provider: GtLOpenAIProvider new.
	
	newChat := GtLChat new.
	newChat provider: GtLOpenAIProvider new.
	
	compactionMessage := GtLOpenAICompactionMessage new.
	compactionMessage rawData: Dictionary new.
	compactionMessage chat: originalChat.
	copiedCompaction := compactionMessage copyForIndependentRequestInChat: newChat.
	
	self assertCopiedChatMessage: copiedCompaction isCopyOf: compactionMessage forChat: newChat.
	self assert: compactionMessage chat == originalChat.
	
	^ copiedCompaction
]

{ #category : #examples }
GtLOpenAIProviderCopyChatExamples >> copyOpenAIUserMessage [
	<gtExample>
	<return: #GtLOpenAIUserMessage>
	| originalChat newChat userMessage copiedUser |
	
	originalChat := GtLChat new.
	originalChat provider: GtLOpenAIProvider new.
	
	newChat := GtLChat new.
	newChat provider: GtLOpenAIProvider new.
	
	userMessage := GtLOpenAIUserMessage new.
	userMessage string: 'User'.
	userMessage chat: originalChat.
	copiedUser := userMessage copyForIndependentRequestInChat: newChat.
	
	self assertCopiedChatMessage: copiedUser isCopyOf: userMessage forChat: newChat.
	self assert: userMessage chat == originalChat.
	
	^ copiedUser
]

{ #category : #examples }
GtLOpenAIProviderCopyChatExamples >> copyReplyMessageWithToolAndOpenAIAssistantMessage [
	<gtExample>
	<return: #GtLReplyMessage>
	| originalChat newChat userMessage toolMessage toolCall assistantMessage replyMessage copiedReply copiedToolMessage |
	
	originalChat := GtLChat new.
	originalChat provider: GtLOpenAIProvider new.
	
	newChat := GtLChat new.
	newChat provider: GtLOpenAIProvider new.
	
	userMessage := GtLOpenAIUserMessage new.
	userMessage string: 'User'.
	userMessage chat: originalChat.
	
	toolCall := GtLFunctionToolCall new.
	toolCall
		name: 'search';
		arguments: Dictionary new;
		result: (GtLString forString: 'Tool output').
	toolMessage := GtLToolMessage new.
	toolMessage toolCall: toolCall.
	toolMessage beFinishedExecutionState.
	toolMessage chat: originalChat.
	
	assistantMessage := GtLOpenAIAssistantMessage new.
	assistantMessage rawData: { 
		'content' -> { { 'text' -> 'Assistant' } asDictionary } } asDictionary.
	assistantMessage chat: originalChat.
	
	replyMessage := GtLReplyMessage new.
	replyMessage chat: originalChat.
	replyMessage userMessage: userMessage.
	replyMessage addToolMessage: toolMessage.
	replyMessage finalMessage: assistantMessage.
	
	copiedReply := replyMessage copyForIndependentRequestInChat: newChat.
	copiedToolMessage := copiedReply executionMessages first.
	
	self assertCopiedReplyMessage: copiedReply isCopyOf: replyMessage forChat: newChat.
	self assertCopiedChatMessage: copiedToolMessage isCopyOf: toolMessage forChat: newChat.
	self assert: copiedToolMessage == replyMessage executionMessages first.
	self assert: copiedReply executionMessages first == copiedToolMessage.
	self assert: replyMessage userMessage chat == originalChat.
	self assert: replyMessage finalMessage chat == originalChat.
	self assert: replyMessage executionMessages first chat == newChat.
	
	^ copiedReply
]
