"
I represent one complete work-graph list row. The columned list adds my cells directly; I retain the event model and provide the row's identity, selection and hover presentation.
"
Class {
	#name : #GtLACPWorkGraphListRowElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'row'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #initialization }
GtLACPWorkGraphListRowElement >> initialize [
	super initialize.
	self
		hMatchParent;
		vFitContent;
		layout: (BlLinearLayout horizontal alignCenterLeft
				cellSpacing: BrColumn defaultCellSpacing);
		padding: BlInsets empty;
		addAptitude: BrGlamorousListItemAptitude
]

{ #category : #accessing }
GtLACPWorkGraphListRowElement >> row [
	^ row
]

{ #category : #accessing }
GtLACPWorkGraphListRowElement >> row: anEvent [
	row := anEvent.
	self id: ('acp-work-graph-event-' , row index asString) asSymbol
]
