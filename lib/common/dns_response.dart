enum DnsResponseMeaning { success, domainMissing, refused, serverError, other }

DnsResponseMeaning dnsResponseMeaning(String code) =>
    switch (code.toUpperCase()) {
      'NOERROR' => DnsResponseMeaning.success,
      'NXDOMAIN' => DnsResponseMeaning.domainMissing,
      'REFUSED' => DnsResponseMeaning.refused,
      'SERVFAIL' => DnsResponseMeaning.serverError,
      _ => DnsResponseMeaning.other,
    };
