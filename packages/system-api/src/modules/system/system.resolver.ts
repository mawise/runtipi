import { Authorized, Mutation, Query, Resolver } from 'type-graphql';
import SystemService from './system.service';
import { SystemInfoResponse, VersionResponse } from './system.types';

@Resolver()
export default class AuthResolver {
  @Query(() => SystemInfoResponse, { nullable: true })
  async systemInfo(): Promise<SystemInfoResponse> {
    return SystemService.systemInfo();
  }

  @Query(() => VersionResponse)
  async version(): Promise<VersionResponse> {
    return SystemService.getVersion();
  }

  @Authorized()
  @Mutation(() => Boolean)
  async restart(): Promise<boolean> {
    return SystemService.restart();
  }

  @Authorized()
  @Mutation(() => Boolean)
  async update(): Promise<boolean> {
    return SystemService.update();
  }
}
