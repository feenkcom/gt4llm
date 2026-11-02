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

{ #category : #views }
GtLACPSessionGroup >> gtConversationTreeFor: aView [
	<gtView>
	| tree cache |
	cache := IdentityDictionary new.
	tree := aView columnedTree
			title: 'Conversation tree';
			priority: 4;
			items: [ self items
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
			actionUpdateButtonTooltip: 'Refresh conversation tree'.
	self items
		ifNotEmpty: [ tree
				updateWhen: GtLACPConversationTreeChanged
				in: [ self items first connection announcer ] ].
	^ tree
]
