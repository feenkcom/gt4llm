Class {
	#name : #GtLPhlowSummarizersChangedListener,
	#superclass : #Object,
	#instVars : [
		'summarizersRegistry',
		'actionExecutor',
		'onSummarizersChangedAction'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #factory }
GtLPhlowSummarizersChangedListener class >> installOnCompositeElement: aTabGroup forRegistry: aSummarizersRegistry [
	| aListener aCompositeView aUserDataKey |
	aUserDataKey := GtLPhlowSummarizersChangedListener class>>#installOnCompositeElement:forRegistry:.
	aTabGroup userData
		at: aUserDataKey
		ifPresent: [ :theListener | ^ theListener ]
		ifAbsent: [ "ignore" ].

	aCompositeView := aTabGroup phlow entity ifNil: [ ^ nil ].
	"aBuildContext := aCompositeView buildContext."
	"aBuildContext isBuildContext ifFalse: [ ^ nil ]."
	
	aListener := self new
			summarizersRegistry: aSummarizersRegistry;
			actionExecutor: (GtPhlowChangeTabGroupActionExecutor new 
					tabGroup: aTabGroup);
			onSummarizersChangedAction: (GtLPhlowChangeTabGroupModifySummarizersTabAction new
					tabGroup: aTabGroup";
					buildContext: aBuildContext");
			subscribeToSummarizersRegistry.

	aTabGroup userData at: aUserDataKey put: aListener.
	
	^ aListener
]

{ #category : #callbacks }
GtLPhlowSummarizersChangedListener >> actOnSummarizersChanged: anAnnouncement [
		actionExecutor
				submit: onSummarizersChangedAction
				context: (GtLPhlowChangeActionAffectedSummarizersContext
					newSummarizers: anAnnouncement newSummarizers).
]

{ #category : #accessing }
GtLPhlowSummarizersChangedListener >> actionExecutor: anActionExecutor [
	actionExecutor := anActionExecutor
]

{ #category : #configuring }
GtLPhlowSummarizersChangedListener >> onSummarizersChangedAction: anAction [ 
	onSummarizersChangedAction := anAction 
]

{ #category : #subscriptions }
GtLPhlowSummarizersChangedListener >> subscribeToSummarizersRegistry [
	summarizersRegistry announcer weak
		when: GtLToolCallSummarizersChanged
			send: #actOnSummarizersChanged:
			to: self
]

{ #category : #accessing }
GtLPhlowSummarizersChangedListener >> summarizersRegistry: aSummarizersRegistry [ 
	summarizersRegistry := aSummarizersRegistry 
]

{ #category : #subscriptions }
GtLPhlowSummarizersChangedListener >> unsubscribeFromSummarizersRegistry [
]
