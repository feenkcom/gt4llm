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

{ #category : #asserting }
GtLOpenAIProviderCopyChatExamples >> assertForkedChat: aForkedChat from: anOriginalChat hasReplyWithExecutionMessagesCount: anInteger hasFinalMessage: aBoolean [
	| originalMessages forkedMessages originalReply forkedReply |
	
	originalMessages := anOriginalChat messages asArray.
	forkedMessages := aForkedChat messages asArray.
	originalReply := originalMessages second.
	forkedReply := forkedMessages second.
	
	self assert: aForkedChat ~~ anOriginalChat.
	self assert: forkedMessages size equals: 2.
	self assert: (forkedMessages allSatisfy: [ :each | each chat == aForkedChat ]).
	self assertCopiedChatMessage: forkedMessages first isCopyOf: originalMessages first forChat: aForkedChat.
	self assert: forkedReply class equals: GtLReplyMessage.
	self assert: forkedReply chat == aForkedChat.
	self assert: forkedReply userMessage == forkedMessages first.
	self assert: forkedReply executionMessages size equals: anInteger.
	self assert: (forkedReply executionMessages allSatisfy: [ :each | each chat == aForkedChat ]).
	aBoolean
		ifTrue: [
			self assert: forkedReply finalMessage notNil.
			self assert: forkedReply finalMessage class equals: GtLOpenAIAssistantMessage.
			self assert: forkedReply finalMessage chat == aForkedChat ]
		ifFalse: [ self assert: forkedReply finalMessage isNil ].
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
GtLOpenAIProviderCopyChatExamples >> chatWithUserAndReplyWithTwoToolMessages [
	<gtExample>
	<return: #GtLChat>
	| chat userMessage firstToolMessage secondToolMessage assistantMessage replyMessage messages |
	
	chat := GtLChat new.
	chat provider: GtLOpenAIProvider new.
	chat userMessageClass: GtLOpenAIUserMessage.
	
	userMessage := GtLOpenAIUserMessage new.
	userMessage string: 'User'.
	chat addUserMessage: userMessage.
	
	firstToolMessage := self newFinishedToolMessageWithText: 'Tool output 1' forChat: chat.
	secondToolMessage := self newFinishedToolMessageWithText: 'Tool output 2' forChat: chat.
	assistantMessage := GtLOpenAIAssistantMessage new.
	assistantMessage rawData: { 'content' -> { { 'text' -> 'Assistant' } asDictionary } } asDictionary.
	assistantMessage chat: chat.
	
	messages := chat messages asArray.
	replyMessage := messages second.
	replyMessage addToolMessage: firstToolMessage.
	replyMessage addToolMessage: secondToolMessage.
	replyMessage finalMessage: assistantMessage.
	
	self assert: messages size equals: 2.
	self assert: messages first == userMessage.
	self assert: messages second == replyMessage.
	self assert: replyMessage userMessage == userMessage.
	self assert: replyMessage executionMessages size equals: 2.
	self assert: replyMessage finalMessage == assistantMessage.
	self assert: (replyMessage executionMessages allSatisfy: [ :each | each chat == chat ]).
	self assert: assistantMessage chat == chat.
	
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
	self assert: originalMessages size equals: 2.
	self assert: copiedMessages size equals: originalMessages size.
	self assert: originalChat messages size equals: 2.
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
GtLOpenAIProviderCopyChatExamples >> copyChatWithUserAndReplyWithTwoToolMessages [
	<gtExample>
	<return: #GtLChat>
	| originalChat copiedChat originalMessages copiedMessages originalReply copiedReply copiedToolMessages |
	
	originalChat := self chatWithUserAndReplyWithTwoToolMessages.
	copiedChat := originalChat copyForIndependentRequest.
	
	originalMessages := originalChat messages asArray.
	copiedMessages := copiedChat messages asArray.
	originalReply := originalMessages second.
	copiedReply := copiedMessages second.
	copiedToolMessages := copiedReply executionMessages asArray.
	
	self assert: copiedChat ~~ originalChat.
	self assert: originalMessages size equals: 2.
	self assert: copiedMessages size equals: originalMessages size.
	self assert: originalChat messages size equals: 2.
	self assert: (copiedMessages allSatisfy: [ :each | each chat == copiedChat ]).
	self assertCopiedChatMessage: copiedMessages first isCopyOf: originalMessages first forChat: copiedChat.
	self assertCopiedReplyMessage: copiedReply isCopyOf: originalReply forChat: copiedChat.
	self assert: copiedReply userMessage == copiedMessages first.
	self assert: copiedToolMessages size equals: 2.
	self assert: copiedToolMessages first chat == copiedChat.
	self assert: copiedToolMessages second chat == copiedChat.
	self assert: copiedReply finalMessage class equals: GtLOpenAIAssistantMessage.
	self assert: (copiedReply executionMessages at: 1) ~~ (originalReply executionMessages at: 1).
	self assert: (copiedReply executionMessages at: 2) ~~ (originalReply executionMessages at: 2).
	self assert: (copiedReply executionMessages at: 1) == (copiedToolMessages at: 1).
	self assert: (copiedReply executionMessages at: 2) == (copiedToolMessages at: 2).
	
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
	| originalChat newChat userMessage firstToolMessage secondToolMessage thirdToolMessage assistantMessage replyMessage copiedReply copiedToolMessages |
	
	originalChat := GtLChat new.
	originalChat provider: GtLOpenAIProvider new.
	originalChat userMessageClass: GtLOpenAIUserMessage.
	
	newChat := GtLChat new.
	newChat provider: GtLOpenAIProvider new.
	newChat userMessageClass: GtLOpenAIUserMessage.
	
	userMessage := GtLOpenAIUserMessage new.
	userMessage string: 'User'.
	userMessage chat: originalChat.
	
	firstToolMessage := self 
		newFinishedToolMessageWithText: 'Tool output 1' forChat: originalChat.
	secondToolMessage := self 
		newFinishedToolMessageWithText: 'Tool output 2' forChat: originalChat.
	thirdToolMessage := self 
		newFinishedToolMessageWithText: 'Tool output 3' forChat: originalChat.
	
	assistantMessage := GtLOpenAIAssistantMessage new.
	assistantMessage rawData: { 'content' -> { { 'text' -> 'Assistant' } asDictionary } } asDictionary.
	assistantMessage chat: originalChat.
	
	replyMessage := GtLReplyMessage new.
	replyMessage chat: originalChat.
	replyMessage userMessage: userMessage.
	replyMessage addToolMessage: firstToolMessage.
	replyMessage addToolMessage: secondToolMessage.
	replyMessage addToolMessage: thirdToolMessage.
	replyMessage finalMessage: assistantMessage.
	
	copiedReply := replyMessage copyForIndependentRequestInChat: newChat.
	copiedToolMessages := copiedReply executionMessages asArray.
	
	self assertCopiedReplyMessage: copiedReply isCopyOf: replyMessage forChat: newChat.
	self assert: copiedToolMessages size equals: 3.
	self assertCopiedChatMessage: copiedToolMessages first isCopyOf: firstToolMessage forChat: newChat.
	self assertCopiedChatMessage: copiedToolMessages second isCopyOf: secondToolMessage forChat: newChat.
	self assertCopiedChatMessage: copiedToolMessages third isCopyOf: thirdToolMessage forChat: newChat.
	self assert: copiedToolMessages first ~~ (replyMessage executionMessages at: 1).
	self assert: copiedToolMessages second ~~ (replyMessage executionMessages at: 2).
	self assert: copiedToolMessages third ~~ (replyMessage executionMessages at: 3).
	self assert: copiedReply userMessage chat == newChat.
	self assert: copiedReply finalMessage chat == newChat.
	self assert: ((copiedReply executionMessages collect: [ :each | each chat ]) asArray allSatisfy: [ :each | each == newChat ]).
	
	^ copiedReply
]

{ #category : #examples }
GtLOpenAIProviderCopyChatExamples >> forkChatAtEntireReplyMessage [
	<gtExample>
	<return: #GtLChat>
	| originalChat replyMessage forkedChat |
	
	originalChat := self chatWithUserAndReplyWithTwoToolMessages.
	replyMessage := originalChat messages asArray second.
	forkedChat := originalChat forkAtMessage: replyMessage.
	
	self assert: originalChat messages size equals: 2.
	self
		assertForkedChat: forkedChat
		from: originalChat
		hasReplyWithExecutionMessagesCount: 2
		hasFinalMessage: true.
	
	^ forkedChat
]

{ #category : #examples }
GtLOpenAIProviderCopyChatExamples >> forkChatAtFinalAssistantMessage [
	<gtExample>
	<return: #GtLChat>
	| originalChat replyMessage forkedChat |
	
	originalChat := self chatWithUserAndReplyWithTwoToolMessages.
	replyMessage := originalChat messages asArray second.
	forkedChat := originalChat forkAtMessage: replyMessage finalMessage.
	
	self assert: originalChat messages size equals: 2.
	self
		assertForkedChat: forkedChat
		from: originalChat
		hasReplyWithExecutionMessagesCount: 2
		hasFinalMessage: true.
	
	^ forkedChat
]

{ #category : #examples }
GtLOpenAIProviderCopyChatExamples >> forkChatAtFirstToolMessage [
	<gtExample>
	<return: #GtLChat>
	| originalChat replyMessage forkedChat |
	
	originalChat := self chatWithUserAndReplyWithTwoToolMessages.
	replyMessage := originalChat messages asArray second.
	forkedChat := originalChat forkAtMessage: replyMessage executionMessages first.
	
	self assert: originalChat messages size equals: 2.
	self
		assertForkedChat: forkedChat
		from: originalChat
		hasReplyWithExecutionMessagesCount: 1
		hasFinalMessage: false.
	
	^ forkedChat
]

{ #category : #examples }
GtLOpenAIProviderCopyChatExamples >> forkChatAtSecondToolMessage [
	<gtExample>
	<return: #GtLChat>
	| originalChat replyMessage forkedChat |
	
	originalChat := self chatWithUserAndReplyWithTwoToolMessages.
	replyMessage := originalChat messages asArray second.
	forkedChat := originalChat forkAtMessage: replyMessage executionMessages second.
	
	self assert: originalChat messages size equals: 2.
	self
		assertForkedChat: forkedChat
		from: originalChat
		hasReplyWithExecutionMessagesCount: 2
		hasFinalMessage: false.
	
	^ forkedChat
]

{ #category : #private }
GtLOpenAIProviderCopyChatExamples >> newFinishedToolMessageWithText: aString forChat: aChat [
	| toolCall toolMessage |
	
	toolCall := GtLFunctionToolCall new.
	toolCall
		name: 'search';
		arguments: Dictionary new;
		result: (GtLString forString: aString).
	toolMessage := GtLToolMessage new.
	toolMessage toolCall: toolCall.
	toolMessage beFinishedExecutionState.
	toolMessage chat: aChat.
	
	^ toolMessage
]
