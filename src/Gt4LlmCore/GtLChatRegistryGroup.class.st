Class {
	#name : #GtLChatRegistryGroup,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#category : #'Gt4LlmCore-UI - Registry'
}

{ #category : #'gt - extensions' }
GtLChatRegistryGroup >> gtRegistryInspectChatActionFor: anAction context: aPhlowContext [
	<gtAction>
	^ anAction button
		id: #'chat--inspect';
		target: GtLChatRegistryActionTarget;
		icon: BrGlamorousVectorIcons inspect;
		tooltip: 'Inspect';
		menuItemPreview: [ '{1} {2}'
				format: {self size.
						'chat' asPluralBasedOn: self size} ];
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | aButton phlow spawnObject: self ]
]

{ #category : #'gt - extensions' }
GtLChatRegistryGroup >> gtRegistryRemoveChatActionFor: anAction context: aPhlowContext [
	<gtAction>
	| aRegistry |
	aRegistry := aPhlowContext at: #chatRegistry ifAbsent: [ ^ anAction noAction ].


	^ anAction button
		id: #'chat--remove';
		target: GtLChatRegistryActionTarget;
		icon: BrGlamorousVectorIcons bin;
		tooltip: 'Remove';
		menuItemPreview: [ '{1} {2}'
				format: {self size.
						'chat' asPluralBasedOn: self size} ];
		menuItemGroup: BrMenuItemGroupConfiguration removal;
		action: [ :aButton | self copy do: [ :eachChat | aRegistry removeChat: eachChat ] ]
]

{ #category : #'gt - extensions' }
GtLChatRegistryGroup >> gtViewChatsOn: aView context: aPhlowContext [
	<gtView>
	^ aView columnedList
		title: 'Chats';
		priority: 20;
		items: [ self ];
		column: 'Chat' text: [ :aChat | aChat ];
		column: 'Started'
			text: [ :aChat | 
				aChat messages
					ifNotEmpty: [ :messages | messages first createdAt asLocalStringYMDHMS ]
					ifEmpty: [ '-' ] ]
			width: 130;
		column: 'Finished'
			text: [ :aChat | aChat messages isEmpty or: [ aChat isFinishedSuccesss ] ]
			width: 100;
		dynamicContextItems: [ :anElement :aChat | 
			GtLChatRegistryActionTarget
				menuItemsForObject: aChat
				inContext: GtPhlowContext new
				hostElement: anElement ]
]
