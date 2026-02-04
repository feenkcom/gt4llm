Class {
	#name : #GtLChatStep,
	#superclass : #BlDevScripterToolActionStep,
	#category : 'Gt4LlmCore-Examples-Scripter'
}

{ #category : #'steps - checks' }
GtLChatStep >> assertMessageElementExistsWithIndex: anIndex [
	^ self assert
		label: ('Assert message element with index {1} exists' format: {anIndex});
		exists;
		onThisOrDeepChildElementId: #'chat--message-list';
		/ #scrollable;
		// (GtLMessageElementId indexed: anIndex)
]

{ #category : #'steps - checks' }
GtLChatStep >> assertMessageElementHasEmptyStateWithIndex: anIndex [
	^ self assertMessageElementWithIndex: anIndex hasChatStateNamed: ''
]

{ #category : #'steps - checks' }
GtLChatStep >> assertMessageElementHasFinishedStateWithIndex: anIndex [
	^ self
		assertMessageElementWithIndex: anIndex
		hasChatStateNamed: GtLMessageState finished messageExecutionStateLabel
]

{ #category : #'steps - checks' }
GtLChatStep >> assertMessageElementHasRunningStateWithIndex: anIndex [
	^ self
		assertMessageElementWithIndex: anIndex
		hasChatStateNamed: GtLMessageState running messageExecutionStateLabel
]

{ #category : #'steps - checks' }
GtLChatStep >> assertMessageElementHasToolSenderNameWithIndex: anIndex [
	^ self assertMessageElementWithIndex: anIndex hasSenderNamed: 'Tool'
]

{ #category : #'steps - checks' }
GtLChatStep >> assertMessageElementHasWaitingSenderNameWithIndex: anIndex [
	^ self assertMessageElementWithIndex: anIndex hasSenderNamed: 'Waiting'
]

{ #category : #'steps - checks' }
GtLChatStep >> assertMessageElementHasWaitingStateWithIndex: anIndex [
	^ self
		assertMessageElementWithIndex: anIndex
		hasChatStateNamed: GtLMessageState created messageExecutionStateLabel
]

{ #category : #'steps - checks' }
GtLChatStep >> assertMessageElementWithIndex: anIndex hasChatStateNamed: aChatStateName [
	^ self assert
		label: ('Assert message element with index {1} has chat state named {2}'
				format: {anIndex.
						aChatStateName});
		value: [ :aLabel | aLabel text asString ] equals: aChatStateName;
		onThisOrDeepChildElementId: #'chat--message-list';
		/ #scrollable;
		// (GtLMessageElementId indexed: anIndex);
		// #'chat--message-state'
]

{ #category : #'steps - checks' }
GtLChatStep >> assertMessageElementWithIndex: anIndex hasSenderNamed: aSenderName [
	^ self assert
		label: ('Assert message element with index {1} has sender named {2}'
				format: {anIndex.
						aSenderName});
		value: [ :aLabel | aLabel text asString ] equals: aSenderName;
		onThisOrDeepChildElementId: #'chat--message-list';
		/ #scrollable;
		// (GtLMessageElementId indexed: anIndex);
		// #'chat--message-sender'
]

{ #category : #'steps - checks' }
GtLChatStep >> assertNewMessageIsWithExceptionNumber: anIndex text: anExceptionString [
	| aStep |
	aStep := self
			substeps2: 'Assert exception element'
			do: [ :aSubStep | 
				aSubStep assert
					onParentStepTarget: aSubStep;
					label: 'Assert exception element exists';
					exists.

				aSubStep assert
					onParentStepTarget: aSubStep;
					// BlAttributedTextElement;
					label: ('Assert exception element label is: {1}' format: {anExceptionString});
					value: [ :aLabel | aLabel text asString ] equals: anExceptionString ].

	aStep
		// GtLNewMessageElement;
		// (#'chat--new-exception' asBlocElementId indexed: anIndex).

	^ aStep
]

{ #category : #'steps - checks' }
GtLChatStep >> assertNewMessageIsWithoutExceptions [
	^ self assert
		label: 'Assert exception element does not exist';
		onParentStepTarget: self;
		// GtLNewMessageElement;
		// GtLExceptionElement;
		notExists
]

{ #category : #'steps - checks' }
GtLChatStep >> assertNewMessageSendButtonIsEnabled [
	| aStep |
	aStep := self
			substeps2: 'Assert send button'
			do: [ :aSubStep | 
				aSubStep assert
					onParentStepTarget: aSubStep;
					label: 'Assert send button is visible';
					value: [ :aLabel | aLabel visibility ] equals: BlVisibility visible.

				aSubStep assert
					onParentStepTarget: aSubStep;
					label: 'Assert send button is enabled';
					satisfies: [ :aLabel | aLabel isEnabled ] ].

	aStep
		// GtLNewMessageElement;
		// #'chat--new-send'.

	^ aStep
]

{ #category : #'steps - checks' }
GtLChatStep >> assertNewMessageStopButtonIsDisabled [
	| aStep |
	aStep := self
			substeps2: 'Assert stop button'
			do: [ :aSubStep | 
				aSubStep assert
					onParentStepTarget: aSubStep;
					label: 'Assert stop button is not visible';
					value: [ :aLabel | aLabel visibility ] equals: BlVisibility gone.

				aSubStep assert
					onParentStepTarget: aSubStep;
					label: 'Assert stop button is disabled';
					satisfies: [ :aLabel | aLabel isDisabled ] ].

	aStep
		// GtLNewMessageElement;
		// #'chat--new-stop'.

	^ aStep
]

{ #category : #'steps - checks' }
GtLChatStep >> assertNewMessageTextIs: aString [
	^ self editor
		label: 'New message editor';
		onParentStepTarget: self;
		// GtLNewMessageElement;
		// #'chat--new-contents';
		assertTextEqualsTo: aString
]

{ #category : #'steps - checks' }
GtLChatStep >> assertNumberOfMessageElementsIs: aCount [
	^ self assert
		label: ('Assert number of message elements is {1}' format: {aCount});
		value: [ :anInfiniteElement | 
				(anInfiniteElement children
					reject: [ :each | each isKindOf: GtLNewMessageElement ]) size ]
			equals: aCount;
		onThisOrDeepChildElementId: #'chat--message-list';
		/ #scrollable
]

{ #category : #'steps - interactions' }
GtLChatStep >> clickCloseExceptionNumber: anIndex [
	^ self click
		label: 'Send message';
		// GtLNewMessageElement;
		// (#'chat--new-exception' asBlocElementId indexed: anIndex);
		// #'chat--new-exception-close'
]

{ #category : #'steps - interactions' }
GtLChatStep >> clickSendMessage [
	^ self click
		label: 'Send message';
		// GtLNewMessageElement;
		// #'chat--new-send'
]

{ #category : #'steps - interactions' }
GtLChatStep >> typeNewMessage: aString [
	^ self editor
		label: 'New message editor';
		onParentStepTarget: self;
		// GtLNewMessageElement;
		// #'chat--new-contents';
		requestFocus;
		assertHasFocus;
		typeText: aString
]
