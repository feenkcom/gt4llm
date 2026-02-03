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
