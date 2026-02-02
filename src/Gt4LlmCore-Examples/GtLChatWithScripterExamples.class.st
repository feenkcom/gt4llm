Class {
	#name : #GtLChatWithScripterExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-UI'
}

{ #category : #examples }
GtLChatWithScripterExamples >> chatElementWithEmptyMessages [
	<gtExample>
	| chat scripter |
	chat := self emptyChat.
	scripter := BlScripter new
			model: chat;
			element: chat asElement.

	self assert: chat messages size equals: 0.

	scripter llmChat
		assertNumberOfMessageElementsIs: 0;
		play.

	^ scripter
]

{ #category : #examples }
GtLChatWithScripterExamples >> chatElementWithEmptyReplyMessage [
	<gtExample>
	| chat scripter |
	chat := self chatWithEmptyReplyMessage.
	scripter := BlScripter new.
	scripter
		element: chat asElement;
		model: chat.

	scripter assert
		exists;
		label: 'Reply message element exists';
		// (GtLMessageElementId indexed: 2);
		play.

	scripter llmChat
		assertNumberOfMessageElementsIs: 2;
		assertMessageElementExistsWithIndex: 2;
		assertMessageElementHasWaitingSenderNameWithIndex: 2;
		assertMessageElementHasEmptyStateWithIndex: 2;
		play.

	^ scripter
]

{ #category : #examples }
GtLChatWithScripterExamples >> chatElementWithEmptyReplyMessage_toolMessage [
	<gtExample>
	| chat scripter call reply tool |
	scripter := self chatElementWithEmptyReplyMessage.
	chat := scripter model.

	call := GtLToolForClassSearchExamples new searchClassesWithMatches.
	tool := GtLToolMessage new toolCall: call.

	scripter do
		label: 'Add tool message';
		block: [ chat addToolMessage: tool ];
		play.

	self assert: chat messages size equals: 2.
	reply := chat messages at: 2.
	self assert: reply isReplyMessage.
	self assert: reply isToolMessage not.
	self assert: reply toolMessages size equals: 1.
	self assert: (reply toolMessages at: 1) equals: tool.

	scripter llmChat
		assertNumberOfMessageElementsIs: 2;
		assertMessageElementExistsWithIndex: 2;
		assertMessageElementHasToolSenderNameWithIndex: 2;
		assertMessageElementHasWaitingStateWithIndex: 2;
		play.

	^ scripter
]

{ #category : #examples }
GtLChatWithScripterExamples >> chatElementWithEmptyReplyMessage_toolMessage_executing [
	<gtExample>
	| chat scripter reply tool |
	scripter := self chatElementWithEmptyReplyMessage_toolMessage.
	chat := scripter model.
	reply := chat messages at: 2.
	tool := reply toolMessages last.

	scripter do
		label: 'Set tool message running state';
		block: [ tool beRunningExecutionState ];
		play.

	scripter llmChat
		assertNumberOfMessageElementsIs: 2;
		assertMessageElementExistsWithIndex: 2;
		assertMessageElementHasToolSenderNameWithIndex: 2;
		assertMessageElementHasRunningStateWithIndex: 2;
		play.

	^ scripter
]

{ #category : #examples }
GtLChatWithScripterExamples >> chatElementWithEmptyReplyMessage_toolMessage_finished [
	<gtExample>
	| chat scripter reply tool |
	scripter := self chatElementWithEmptyReplyMessage_toolMessage_executing.
	chat := scripter model.
	reply := chat messages at: 2.
	tool := reply toolMessages last.

	scripter do
		label: 'Set tool message finished state';
		block: [ tool beFinishedExecutionState ];
		play.

	scripter llmChat
		assertNumberOfMessageElementsIs: 2;
		assertMessageElementExistsWithIndex: 2;
		assertMessageElementHasToolSenderNameWithIndex: 2;
		assertMessageElementHasFinishedStateWithIndex: 2;
		play.

	^ scripter
]

{ #category : #examples }
GtLChatWithScripterExamples >> chatWithEmptyReplyMessage [
	<gtExample>
	| chat currentMessage |
	chat := self emptyChat.
	currentMessage := chat createUserMessage.
	currentMessage
		addInputMagritteObject: (GtLMarkdown new
				content: 'Explain this object by exploring the classes that it relies upon.')
		named: 'Markdown'.
	chat addUserMessage: currentMessage.

	self assert: chat messages size equals: 2.
	self assert: (chat messages at: 1) isUserMessage.
	self assert: (chat messages at: 2) isToolMessage not.
	self assert: (chat messages at: 2) isAssistantRole not.
	self assert: (chat messages at: 2) isReplyMessage.

	^ chat
]

{ #category : #examples }
GtLChatWithScripterExamples >> emptyChat [
	<gtExample>
	| aChat |
	aChat := GtLChat new provider: GtLOpenAIProviderStub new.
	
	self assert: aChat messages size equals: 0.
	self assert: aChat state equals: GtLProviderState idle.
	
	^ aChat
]
