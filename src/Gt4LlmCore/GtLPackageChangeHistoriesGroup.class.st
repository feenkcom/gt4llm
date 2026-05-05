"
Group of package change histories. Used by {{gtClass:GtLCodeChangesToolCallsSummarizer}} to organize changes by package.

See also:
- {{gtClass:GtLPackageChangeHistory}} - individual package history
- {{gtClass:GtEpiceaPackageHistoriesGroup}} - similar concept in Epicea
"
Class {
	#name : #GtLPackageChangeHistoriesGroup,
	#superclass : #GtLChangeHistoriesGroup,
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #adding }
GtLPackageChangeHistoriesGroup >> addHistory: aHistory [
	self add: aHistory
]

{ #category : #accessing }
GtLPackageChangeHistoriesGroup >> classHistories [
	"Flatten all class histories from all package histories"
	^ GtLClassChangeHistoriesGroup new
		addItems: (self items flatCollect: [ :aPackageHistory | aPackageHistory classHistories items ]);
		yourself
]

{ #category : #views }
GtLPackageChangeHistoriesGroup >> gtViewDetailedHistoriesFor: aView [
	<gtView>
	
	^ aView columnedTree 
		title: 'By package (detailed)';
		priority: 50;
		items: [ self items ];
		children: [ :anEntry | anEntry gtViewChangeHistoryChildren ];
		expandUpTo: 2;
		column: 'Change' do: [ :aColumn |
			aColumn
				cellStencil: [ GtLCodeChangesDetailsElement new ];
				dataBinder: [ :anElement :aCodeChange | anElement codeChange: aCodeChange ] ];
		column: 'Count' text: [ :anEntry | 
			| entryChangesCount |
			entryChangesCount := anEntry gtViewChangesCount.
			entryChangesCount isZero 
				ifTrue: ['']
				ifFalse: [
					entryChangesCount asString
						, ' '
							, ('change' asPluralBasedOn: entryChangesCount) ]] width: 100;
		column: 'Timestamp' text: [ :anEntry | 
			anEntry gtViewChangeEditTime
				ifNil: ['']
				ifNotNil: [ :aDateAndTime | 
					aDateAndTime printToSeconds ]  ] width: 150
]

{ #category : #views }
GtLPackageChangeHistoriesGroup >> gtViewHistoriesFor: aView [
	<gtView>
	
	^ aView columnedTree 
		title: 'By package';
		priority: 20;
		items: [ self items ];
		children: [ :anEntry | anEntry gtViewChangeHistoryChildren ];
		expandUpTo: 2;
		column: 'Change' do: [ :aColumn |
			aColumn
				cellStencil: [ GtLCodeChangesDetailsElement new ];
				dataBinder: [ :anElement :aCodeChange | anElement codeChange: aCodeChange ] ]
]

{ #category : #accessing }
GtLPackageChangeHistoriesGroup >> historyForPackageNamed: aPackageName [
	^ self detect: [ :aPackageHistory | 
		aPackageHistory targetPackageName = aPackageName ]
]
