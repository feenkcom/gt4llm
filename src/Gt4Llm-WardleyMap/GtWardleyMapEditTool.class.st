Class {
	#name : #GtWardleyMapEditTool,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'database'
	],
	#category : #'Gt4Llm-WardleyMap'
}

{ #category : #accessing }
GtWardleyMapEditTool >> changesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Wardley Map changes';
		accessor: #changes;
		classes: (GtWardleyMapChangeSpecification withAllSubclasses select: #isConcrete);
		useExplicitContainerForChildren;
		beRequired
]

{ #category : #accessing }
GtWardleyMapEditTool >> database [
	^ database
]

{ #category : #accessing }
GtWardleyMapEditTool >> database: anObject [
	database := anObject
]

{ #category : #accessing }
GtWardleyMapEditTool >> description [
	^ 'Edits a Lepiter Wardley Map snippet identified by page and snippet ids, updating the nodes, edges and notes.'
]

{ #category : #initialization }
GtWardleyMapEditTool >> initialize [
	super initialize.
	database := LeDatabasesRegistry defaultLogicalDatabase
]

{ #category : #accessing }
GtWardleyMapEditTool >> name [
	^ 'editLepiterWardleyMapSnippet'
]

{ #category : #magritte }
GtWardleyMapEditTool >> pageUidDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid;
		beRequired
]

{ #category : #execution }
GtWardleyMapEditTool >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments changes pageUidString snippetUidString pageUid snippetUid snippets snippet map |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	pageUidString := arguments
			at: #pageUid
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'pageUid' ].
	pageUid := [ UUID fromString36: pageUidString ]
			on: Error
			do: [ :error | 
				^ GtLExceptionDomainObject new
					freeze: error;
					errorReason: 'Invalid page uid' ].
	snippetUidString := (arguments
			at: #snippetUid
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'snippetUid' ]) trimBoth.
	snippetUid := LeUID new.
	[ snippetUid uidString: snippetUidString ]
		on: Error
		do: [ :error | 
			^ GtLExceptionDomainObject new
				freeze: error;
				errorReason: 'Invalid snippet uid' ].
	changes := arguments
			at: #changes
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'changes' ].
	self database
		pageWithID: pageUid
		ifPresent: [ :aPage | 
			snippets := aPage
					allChildrenSnippetsMatching: [ :aSnippet | aSnippet uid = snippetUid ].
			snippets
				ifEmpty: [ ^ GtLProblemDomainObject new
						description: 'Could not locate snippet with id ' , snippetUid uidString ] ]
		ifAbsent: [ ^ GtLProblemDomainObject new
				description: 'Could not locate page with id ' , pageUid asString ].
	[ | idMap |
	snippet := snippets anyOne.
	map := snippet wardleyMap.
	idMap := map newIdMap.
	changes do: [ :each | each updateNewUidsUsing: idMap ].
	changes do: [ :each | each proposeModificationsIn: map ].
	map optionAt: #newIds put: idMap.
	map ensureAllProposition ]
		on: Error
		do: [ :error | 
			^ GtLExceptionDomainObject new
				freeze: error;
				errorReason: 'Error while applying Wardley map change' ].
	^ GtLLepiterSnippetDomainObject new
		status: 'updated';
		pageUid: pageUid asString;
		snippetUid: snippet uidString;
		snippet: snippet
]

{ #category : #magritte }
GtWardleyMapEditTool >> snippetUidDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Snippet uid';
		accessor: #snippetUid;
		beRequired
]
