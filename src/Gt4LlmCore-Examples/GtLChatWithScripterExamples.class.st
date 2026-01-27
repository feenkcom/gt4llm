Class {
	#name : #GtLChatWithScripterExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-UI'
}

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

	scripter assert
		value: [ :aLabel | aLabel text asString ] equals: 'Waiting';
		label: 'Reply message element exists';
		// (GtLMessageElementId indexed: 2);
		// GtLMessageHeaderElement;
		// BrLabel;
		@ 1;
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

	scripter assert
		exists;
		label: 'Assert reply message element exists';
		// (GtLMessageElementId indexed: 2);
		play.

	scripter assert
		value: [ :aLabel | aLabel text asString ] equals: 'Tool';
		label: 'Assert reply message element label is tool';
		// (GtLMessageElementId indexed: 2);
		// GtLMessageHeaderElement;
		// BrLabel;
		@ 1;
		play.
		
	scripter assert
		value: [ :aLabel | aLabel text asString ] equals: GtLMessageState created messageExecutionStateLabel;
		label: 'Assert reply message has waiting state label';
		// (GtLMessageElementId indexed: 2);
		// GtLMessageHeaderElement;
		// BrLabel;
		@ 3;
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

	scripter assert
		value: [ :aLabel | aLabel text asString ] equals: GtLMessageState running messageExecutionStateLabel;
		label: 'Assert reply message has running state label';
		// (GtLMessageElementId indexed: 2);
		// GtLMessageHeaderElement;
		// BrLabel;
		@ 3;
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

	scripter assert
		value: [ :aLabel | aLabel text asString ] equals: GtLMessageState finished messageExecutionStateLabel;
		label: 'Assert reply message has finished state label';
		// (GtLMessageElementId indexed: 2);
		// GtLMessageHeaderElement;
		// BrLabel;
		@ 3;
		play.

	^ scripter
]

{ #category : #examples }
GtLChatWithScripterExamples >> chatWithEmptyReplyMessage [
	<gtExample>
	| chat currentMessage |
	chat := GtLChat new provider: GtLOpenAIProviderStub new.
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
