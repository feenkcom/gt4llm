"
I group ACP sessions and own their conversation-tree view. Sessions and connections forward to me, while TGtGroupWithItems supplies collection behavior.
"
Class {
	#name : #GtLACPSessionGroup,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#instVars : [
		'items'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #'gt - extensions' }
GtLACPSessionGroup class >> conversationTreeFor: aView sessions: aBlock [
	"Build the conversation tree of the root sessions answered by aBlock, which is evaluated on every view update. Senders decide what the tree updates from."

	| cache |
	cache := IdentityDictionary new.
	^ aView columnedTree
		title: 'Conversation tree';
		priority: 4;
		items: [ aBlock value
				collect: [ :session | cache at: session ifAbsentPut: [ session asConversationTreeNode ] ] ];
		children: [ :node | node childrenIn: cache ];
		column: 'Conversation' text: #label;
		column: 'Kind'
			text: #kind
			width: 100;
		column: 'State'
			text: #state
			width: 110;
		column: 'Messages'
			text: [ :each | each messageCount isZero ifTrue: [ '' ] ifFalse: [ each messageCount ] ]
			width: 75;
		column: 'Directory' text: #directory;
		send: #object;
		expandAll;
		actionUpdateButtonTooltip: 'Refresh conversation tree'
]

{ #category : #'gt - extensions' }
GtLACPSessionGroup >> gtConversationTreeFor: aView [
	<gtView>
	| tree |
	tree := self class conversationTreeFor: aView sessions: [ self items ].
	self items
		ifNotEmpty: [ tree
				updateWhen: GtLACPConversationTreeChanged
				in: [ self items first connection announcer ] ].
	^ tree
]
