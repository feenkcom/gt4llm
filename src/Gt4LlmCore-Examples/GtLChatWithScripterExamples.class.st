Class {
	#name : #GtLChatWithScripterExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-UI'
}

{ #category : #examples }
GtLChatWithScripterExamples >> chatElementMarkdownAndInputObject [
	<gtExample>
	| chat scripter |
	scripter := self chatElementWithEmptyMessages.
	chat := scripter model.

	chat
		sendWith: [ :msg | 
			msg
				markdown: 'Explain this object by exploring the classes that it relies upon.';
				addPlainInputObject: GtABCartoonAddressBookExample new cartoonAddressBook
					named: 'Object' ].

	self assert: chat messages size equals: 2.

	scripter llmChat
		assertNewMessageTextIs: '';
		assertNewMessageSendButtonIsEnabled;
		assertNewMessageStopButtonIsDisabled;
		assertNumberOfMessageElementsIs: 2;
		assertMessageElementWithIndex: 1
			hasHeaderContent: 'Explain this object by exploring the classes that it relies upon. Object: Cartoons';
		play.

	^ scripter
]

{ #category : #examples }
GtLChatWithScripterExamples >> chatElementMarkdownAndLepiterPage [
	<gtExample>
	| chat scripter lepiterPage |
	scripter := self chatElementWithEmptyMessages.
	chat := scripter model.

	lepiterPage := LeDatabasesRegistry defaultLogicalDatabase pageNamed: 'Releaser'.

	chat
		sendWith: [ :message | 
			message
				markdown: 'Improve the content of the first snippet in this page. Use a LepiterTransformation to express the change.';
				addInputModel: (GtLLepiterPageInputModel new
						name: lepiterPage title;
						model: lepiterPage);
				addResponseFormat: (GtLResponseMagritteFormat new
						name: 'LepiterTransformations';
						modelClass: GtLLepiterTransformations) ].

	self assert: chat messages size equals: 2.

	scripter llmChat
		assertNewMessageTextIs: '';
		assertNewMessageSendButtonIsEnabled;
		assertNewMessageStopButtonIsDisabled;
		assertNumberOfMessageElementsIs: 2;
		assertMessageElementWithIndex: 1
			hasHeaderContent: 'Improve the content of the first snippet in this page. Use a LepiterTransformation to express the change. Page: Releaser';
		play.

	^ scripter
]

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
GtLChatWithScripterExamples >> chatElementWithNewMessage [
	<gtExample>
	| chat scripter |
	scripter := self chatElementWithEmptyMessages.
	chat := scripter model.

	self assert: chat messages size equals: 0.

	scripter llmChat
		typeNewMessage: 'What is GToolkit?';
		assertNewMessageTextIs: 'What is GToolkit?';
		assertNewMessageSendButtonIsEnabled;
		assertNewMessageStopButtonIsDisabled;
		assertNumberOfMessageElementsIs: 0;
		play.

	^ scripter
]

{ #category : #examples }
GtLChatWithScripterExamples >> chatElementWithNewMessage_send [
	<gtExample>
	| chat scripter |
	scripter := self chatElementWithNewMessage.
	chat := scripter model.

	self assert: chat messages size equals: 0.

	scripter llmChat
		clickSendMessage;
		assertNewMessageTextIs: '';
		assertNewMessageSendButtonIsEnabled;
		assertNewMessageStopButtonIsDisabled;
		assertNumberOfMessageElementsIs: 2;
		assertMessageElementHasWaitingSenderNameWithIndex: 2;
		assertMessageElementHasEmptyStateWithIndex: 2;
		assertMessageElementHasUserSenderNameWithIndex: 1;
		assertMessageElementWithIndex: 1 hasHeaderContent: 'What is GToolkit?';
		play.

	^ scripter
]

{ #category : #examples }
GtLChatWithScripterExamples >> chatElementWithNewMessage_sendWithException [
	<gtExample>
	| chat scripter |
	scripter := self chatElementWithNewMessage.
	chat := scripter model.

	self assert: chat messages size equals: 0.

	chat provider
		sendMessageBlock: [ :aMessage | 
			GtLOpenAIError new
				messageText: 'Cannot send message';
				type: 'error';
				param: 'input';
				code: 305;
				signal ].

	scripter llmChat
		clickSendMessage;
		assertNewMessageTextIs: '';
		assertNewMessageSendButtonIsEnabled;
		assertNewMessageStopButtonIsDisabled;
		assertNumberOfMessageElementsIs: 2;
		assertMessageElementHasWaitingSenderNameWithIndex: 2;
		assertMessageElementHasEmptyStateWithIndex: 2;
		assertNewMessageIsWithExceptionNumber: 1
			text: 'GtLOpenAIError: Cannot send message';
		play.

	^ scripter
]

{ #category : #examples }
GtLChatWithScripterExamples >> chatElementWithNewMessage_sendWithException_close [
	<gtExample>
	| chat scripter |
	scripter := self chatElementWithNewMessage_sendWithException.
	chat := scripter model.

	scripter llmChat
		clickCloseExceptionNumber: 1;
		assertNewMessageIsWithoutExceptions;
		play.

	^ scripter
]

{ #category : #examples }
GtLChatWithScripterExamples >> chatElementWithNewMessage_sendWithException_second [
	<gtExample>
	| chat scripter |
	scripter := self chatElementWithNewMessage_sendWithException.
	chat := scripter model.

	self assert: chat messages size equals: 2.

	chat provider
		sendMessageBlock: [ :aMessage | 
			Error new
				messageText: 'Another problem';
				signal ].

	scripter llmChat
		typeNewMessage: 'Answer the previous question.';
		clickSendMessage;
		assertNewMessageTextIs: '';
		assertNewMessageSendButtonIsEnabled;
		assertNewMessageStopButtonIsDisabled;
		assertNumberOfMessageElementsIs: 4;
		assertMessageElementHasWaitingSenderNameWithIndex: 4;
		assertMessageElementHasEmptyStateWithIndex: 4;
		assertNewMessageIsWithExceptionNumber: 1
			text: 'GtLOpenAIError: Cannot send message';
		play.

	^ scripter
]

{ #category : #examples }
GtLChatWithScripterExamples >> chatElementWithNewMessage_sendWithException_second_close [
	<gtExample>
	| chat scripter |
	scripter := self chatElementWithNewMessage_sendWithException_second.
	chat := scripter model.

	scripter llmChat
		clickCloseExceptionNumber: 1;
		clickCloseExceptionNumber: 2;
		assertNewMessageIsWithoutExceptions;
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
