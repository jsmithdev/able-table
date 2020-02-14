/* eslint-disable no-console */
import { api, LightningElement, wire } from 'lwc'
//import { getRecord } from 'lightning/uiRecordApi'
//import { getRecordUi } from 'lightning/uiRecordApi'
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
//import CASE_OBJECT from '@salesforce/schema/Case';


export default class AbleTable extends LightningElement {

    
    @api rows = []
    @api viewable = []
    @api columns = []
    @api recordId

    @wire(getObjectInfo, { objectApiName: 'Case' })
    handleInfo(object_info){
        console.log('object_info')
        if(object_info && typeof object_info.data === 'object'){
            console.log('object_info => ')
            console.dir(object_info.data.feedEnabled)

            const { fields } = object_info.data

            const field_info = Object.keys(fields).map( key => Object.assign({}, fields[key]))

            console.dir(field_info)

            const picklists = field_info.filter(field => field.apiName === "Status")

            console.dir(picklists)
        }
    }

    async connectedCallback(){

        // const test = await 
    }


    @api 
    get objects(){
        return this.data
    }
    set objects(data){

        if(!data){ return }
        
        const [ record ] = data

        const viewable = this.viewable.split(',').map(x => x.trim())

        const fields =  Object.keys(record).filter(field => viewable.includes(field))
        
        const columns = fields.map(field => ({
            label: this.labeler(field),
            fieldName: field
        }))
        
        //console.dir( 'ReactiveTable.set.object data => ' )
        //console.dir( JSON.parse( JSON.stringify( {viewable} ) ) )

        this.columns = columns
        this.row = data
    }

    labeler(raw){

        const s = raw.replace('__c', '').replace(/_/gi, ' ')
        
        return s
    }
}