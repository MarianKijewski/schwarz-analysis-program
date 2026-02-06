using { forty.two.transfer as my } from '../db/schema';

service SendService @(odata:'/send') {
  entity Actor as projection on my.Actor;
  entity Email as projection on my.Email;

  @requires: 'authenticated-user'
  action sendEmail (
    sender    : Actor,
    recipient : Actor,
    email     : Email
  )
}
