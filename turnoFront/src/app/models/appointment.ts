export interface Appointment {
    id: number,
    commerce?: string,
    service?: string,
    startTime: Date,
    endTime: Date,
    status: string
}