"
I render a permission toolbar directly below its tool header. A resolved request displays the chosen option in gray; tool execution remains visible in the normal header.
"
Class {
	#name : #GtLACPPermissionElement,
	#superclass : #GtLACPInteractionElement,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #navigation }
GtLACPPermissionElement >> attentionTarget [
	^ self parent ifNil: [ self ]
]

{ #category : #building }
GtLACPPermissionElement >> buildHeader [
	"The operation's existing tool header identifies this interaction."

	
]

{ #category : #building }
GtLACPPermissionElement >> buildPendingContent [
	self addChild: errorLabel.
	self addChild: self permissionToolbar
]

{ #category : #building }
GtLACPPermissionElement >> buildResolvedContent [
	self
		addChild: ((self secondaryText: self decisionText)
				id: ('acp-permission-decision-' , request requestId asString) asSymbol;
				yourself)
]

{ #category : #accessing }
GtLACPPermissionElement >> decisionText [
	^ request decision
		ifNil: [ 'Permission cancelled' ]
		ifNotNil: [ :option | option name ]
]

{ #category : #initialization }
GtLACPPermissionElement >> initialize [
	super initialize.
	self
		padding: BlInsets empty;
		margin: (BlInsets top: 4 bottom: 2)
]

{ #category : #accessing }
GtLACPPermissionElement >> permission: aPermission [
	request := aPermission.
	self id: ('acp-permission-' , request requestId asString) asSymbol.
	self build
]

{ #category : #building }
GtLACPPermissionElement >> permissionToolbar [
	| toolbar |
	toolbar := self newToolbar
			id: ('acp-permission-toolbar-' , request requestId asString) asSymbol.
	request options
		do: [ :option | 
			toolbar
				addItem: (self
						button: option name
						id: ('acp-permission-' , option id asString) asSymbol
						action: [ option select ]) ].
	^ toolbar
]
